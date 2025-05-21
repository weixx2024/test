local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/控制')
local 状态 = require('对象/基类/状态')

local 主角 = class('主角', 动作, 控制, 状态)
主角.模型表 = { 'stand', 'walk', 'run' } --stand2',

function 主角:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    if not t.名称颜色 or t.名称颜色 == 0 then
        self:置名称颜色(0, 255, 0, 255)
    end
    -- self._定时动作 = 引擎:定时(
    --     3000,
    --     function(ms)
    --         if self.模型 == 'stand' then
    --             self:动作_站立2()
    --         end
    --         return math.random(5, 20) * 1000
    --     end
    -- )
end

function 主角:更新(dt)
    self[动作]:更新(dt)
    self[控制]:更新(dt)
    self[状态]:更新(dt)

    if self.是否移动 then
        界面层:置坐标(self.xy.x, self.xy.y)
    end
end

function 主角:显示(xy)
    local xy = self.xy - xy
    self[状态]:显示底层(xy)
    self[动作]:显示(xy)
    self[状态]:显示名称(xy)
    self[状态]:显示(xy)
end

function 主角:显示顶层(xy)
    xy = self.xy - xy
    self[状态]:显示顶层(xy)
end

function 主角:开始移动(xy, 模式)
    if __rpc and (not self.是否组队 or self.是否队长) then
        if not self.是否移动 then
            if self._定时移动 then
                self._定时移动:删除()
                self._定时移动 = nil
            end
            self._定时移动 = 引擎:定时(
                500,
                function(ms)
                    if not self.是否移动 then
                        __rpc:角色_移动结束(self.xy.x, self.xy.y, self.方向)
                        if __自动任务.开始 and __自动任务.数据.id == __map.id and 取两点距离(__rol.xy.x // 20, (__map.高度 - __rol.xy.y) // 20, __自动任务.数据.x, __自动任务.数据.y) < 3 then
                            __自动任务:进入战斗()
                        end
                        return 0
                    end
                    if (not self.是否组队 or self.是否队长) then
                        __rpc:角色_移动更新(self.xy.x, self.xy.y, self.方向)
                    end
                    return ms
                end
            )
        end

        if xy and xy.是否路径 then
            __rpc:角色_移动开始(xy.x, xy.y, 模式)
            self[控制]:开始移动(xy, 模式)
        end
    end
end

function 主角:取排序点()
    return self.xy.y
end

function 主角:消息事件(t)
    self[状态]:消息事件(t)
    if t.鼠标 then --为什么空了
        for _, v in ipairs(t.鼠标) do
            if v.type == SDL.MOUSE_MOTION then
                local c = self:检查透明(v.x, v.y)
                if c then
                    v.type = nil
                    self:置高亮(true)
                    self:置名称颜色(255, 0, 0, 255)
                elseif self.是否高亮 then
                    self:置高亮(false)
                    self:置名称颜色()
                end
                if 鼠标层.是否组队 then
                    鼠标层:组队形状(c)
                end
            elseif v.type == SDL.MOUSE_UP then
                if self:检查透明(v.x, v.y) then
                    if v.button == SDL.BUTTON_LEFT then
                        v.type = nil
                        if not 鼠标层.是否正常 then
                            if 鼠标层.是否组队 then
                                鼠标层:正常形状()
                                窗口层:创建队伍()
                            elseif 鼠标层.是否好友 then
                                鼠标层:正常形状()
                            elseif 鼠标层.是否交易 then
                                if not self.是否战斗 then
                                    鼠标层:正常形状()
                                end
                            elseif 鼠标层.是否给予 then
                                if not self.是否战斗 then
                                    鼠标层:正常形状()
                                end
                            elseif 鼠标层.是否攻击 then
                                if not self.是否战斗 then
                                    鼠标层:正常形状()
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if t.摆摊 == self then
        窗口层:打开摆摊盘点()
    end
end

return 主角
