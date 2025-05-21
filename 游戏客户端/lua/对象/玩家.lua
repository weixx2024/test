

local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/控制')
local 状态 = require('对象/基类/状态')

local 玩家 = class('玩家', 动作, 控制, 状态)
玩家.模型表 = { 'stand', 'walk', 'run', } --'stand2'

function 玩家:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end

    if not t.名称颜色 or t.名称颜色 == 0 then
        self:置名称颜色(0x78FF8CFF)
    end
    if type(self.是否移动) == 'table' then
        self:开始移动(require('GGE.坐标')(self.是否移动))
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

function 玩家:更新(dt, xy, sxy)
    self[动作]:更新(dt)
    self[控制]:更新(dt, xy)
    self[状态]:更新(dt)
end

function 玩家:显示(xy)
    if not self.隐身 then
        xy = self.xy - xy
        self[状态]:显示底层(xy)
        if not __隐藏玩家 then
            self[动作]:显示(xy)
        end
        if not __隐藏名称 then
            self[状态]:显示名称(xy)
        end
        self[状态]:显示(xy)
    end
end

function 玩家:显示顶层(xy)
    xy = self.xy - xy
    self[状态]:显示顶层(xy)
end

function 玩家:取排序点()
    return self.xy.y
end

function 玩家:检查碰撞(x, y)
    local r
    if not __隐藏玩家 then
        r = self:检查透明(x, y)
    end
    if not r and self._addon.leader then
        return self._addon.leader:检查透明(x, y)
    end
    return r
end

function 玩家:消息事件(t)
    self[状态]:消息事件(t)
    for _, v in ipairs(t.鼠标) do
        if v.type == SDL.MOUSE_MOTION then
            local c = self:检查碰撞(v.x, v.y)
            if c then
                v.type = nil
                self:置高亮(true)
                self:置名称颜色(255, 0, 0, 255)
            elseif self.是否高亮 then
                self:置高亮(false)
                self:置名称颜色()
            end
            if 鼠标层.是否好友 then
                鼠标层:好友形状(c)
            elseif 鼠标层.是否交易 then
                鼠标层:交易形状(c)
            elseif 鼠标层.是否给予 then
                鼠标层:给予形状(c)
            elseif 鼠标层.是否攻击 then
                鼠标层:攻击形状(c)
            elseif 鼠标层.是否组队 then
                鼠标层:组队形状(c)
            end
        elseif v.type == SDL.MOUSE_UP and self:检查碰撞(v.x, v.y) then
            if v.button == SDL.BUTTON_LEFT then
                v.type = nil
                if not 鼠标层.是否正常 then
                    if 鼠标层.是否组队 then
                        -- if self.是否队长 then
                        鼠标层:正常形状()
                        -- 窗口层:申请加入队伍(self.nid)
                        coroutine.xpcall(窗口层.申请加入队伍, 窗口层, self.nid)
                        --  end
                    elseif 鼠标层.是否好友 then
                        鼠标层:正常形状()
                        coroutine.xpcall(function()
                            local r = __rpc:角色_添加好友(self.nid)
                        end)
                    elseif 鼠标层.是否交易 then
                        if not self.是否战斗 then
                            鼠标层:正常形状()
                            coroutine.xpcall(function()
                                local r = __rpc:角色_交易开始(self.nid)
                            end)
                        end
                    elseif 鼠标层.是否给予 then
                        if not self.是否战斗 then
                            鼠标层:正常形状()
                            coroutine.xpcall(窗口层.打开给予, 窗口层, self)
                        end
                    elseif 鼠标层.是否攻击 then
                        if not self.是否战斗 then
                            鼠标层:正常形状()
                            __rpc:角色_攻击(self.nid)
                        end
                    end
                end
            elseif v.button == SDL.BUTTON_RIGHT then
                --界面层:右键玩家(self)
                --界面层:私聊(self) --聊天框
            end
        end
    end
    if t.摆摊 == self then
        窗口层:打开查看购买(self)
    end
end

return 玩家
