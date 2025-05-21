local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/控制')
local 状态 = require('对象/基类/状态')
local NPC = class('NPC', 动作, 控制, 状态)
NPC.模型表 = { 'stand', 'walk' , 'up','upyd','upkp','down','downyd','downkp'}

function NPC:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    if not t.名称颜色 or t.名称颜色 == 0 then
        self:置名称颜色(0xFFFF00FF)
    end
    if t.名称 == "烈火塔" then
        self.火塔特效 = __res:getani('resource/0x7ADFABF8.tcp')
    elseif t.名称 == "玄冰塔" then
        self.冰塔特效 = __res:getani('resource/0xB9B4282E.tcp')
    end
    self.外形 = __res:getshapeid(t.外形)
    self.是否NPC = true
end

function NPC:更新(dt, xy)
    self[动作]:更新(dt)
    self[控制]:更新(dt, xy)
    self[状态]:更新(dt)
    if self.冰塔特效 then
        self.冰塔特效:更新(dt)
    end
    if self.火塔特效 then
        self.火塔特效:更新(dt)
    end
end

function NPC:显示(xy)
    xy = self.xy - xy
    self[状态]:显示底层(xy)
    self[动作]:显示(xy)
    self[状态]:显示名称(xy)
    self[状态]:显示(xy)
    if self.冰塔特效 and self.冰塔特效.是否播放 then
        self.冰塔特效:显示(xy)
    end
    if self.火塔特效 and self.火塔特效.是否播放 then
        self.火塔特效:显示(xy)
    end
end

function NPC:显示顶层(xy)
    xy = self.xy - xy
    self[状态]:显示顶层(xy)
end

function NPC:取排序点()
    return self.xy.y
end

function NPC:消息事件(t)
    self[状态]:消息事件(t)
    if t.鼠标 then--为什么空了
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
                if 鼠标层.是否给予 then
                    鼠标层:给予形状(c)
                end
            elseif v.type == SDL.MOUSE_DOWN then
                if self:检查透明(v.x, v.y) then
                    v.type = nil
                    self._hasdown = true
                end
            elseif v.type == SDL.MOUSE_UP then
                if self._hasdown and self:检查透明(v.x, v.y) and v.button == SDL.BUTTON_LEFT then
                    v.type = nil
                    if 鼠标层.是否正常 then
                        if not __rol.是否组队 or __rol.是否队长 then
                            coroutine.xpcall(窗口层.打开对话, 窗口层, self.nid, self.外形)
                        end
                    elseif 鼠标层.是否给予 then
                        鼠标层:正常形状()
                        coroutine.xpcall(窗口层.打开给予, 窗口层, self)
                    elseif 鼠标层.是否攻击 then
                        鼠标层:正常形状()
                        local a, b = __rpc:角色_攻击(self.nid)
                        if a then
                            窗口层:给予对话(nil, b, a)
                        end
                    end
                end
                self._hasdown = false
            end
        end
    end
end

function NPC:点亮冰塔(r)
    self.冰塔特效:播放(r)
    return true
end

function NPC:点亮火塔(r)
    self.火塔特效:播放(r)
    return true
end

function NPC:修改动作(动作)
    if 动作 == "上移动" then
        self:置模型('upyd')
        -- self:置循环(true)
        self:置停止事件(
            function()
                self:置模型('up')
            end
        )
    elseif 动作 == "下移动" then
        self:置模型('downyd')
        -- self:置循环(true)
        self:置停止事件(
            function()
                self:置模型('down')
            end
        )
    elseif 动作 == "下开炮" then
        self:置模型('downkp')
        -- self:置循环(true)
        self:置停止事件(
            function()
                self:置模型('stand')
            end
        )
    elseif self.模型 == '上开炮' then
        self:置模型('upkp')
        -- self:置循环(true)
        self:置停止事件(
            function()
                self:置模型('stand')
            end
        )
    end

    -- self._定时动作1 = 引擎:定时(
    --     400,
    --     function(ms)
    --         if self.模型 == '上移动' and 当前标识符 == self._动作标识符 then
    --             self:修改动作('上固定')
    --         end
    --     end
    -- )
    -- -- self._定时动作2 = 引擎:定时(
    -- --     20000,
    -- --     function(ms)
    -- --         if self.模型 == '上固定' and 当前标识符 == self._动作标识符 then
    -- --             self:修改动作('上开炮')
    -- --             __rpc:角色_开炮 (2, mnid)
    -- --         end
    -- --     end
    -- -- )
    -- self._定时动作3 = 引擎:定时(
    --     1000,
    --     function(ms)
    --         if self.模型 == '上开炮' and 当前标识符 == self._动作标识符 then
    --             self:修改动作('stand')
    --         end
    --     end
    -- )

    -- self._定时动作1 = 引擎:定时(
    --     400,
    --     function(ms)
    --         if self.模型 == '下移动' and 当前标识符 == self._动作标识符 then
    --             self:修改动作('下固定')
    --         end
    --     end
    -- )
    -- -- self._定时动作2 = 引擎:定时(
    -- --     20000,
    -- --     function(ms)
    -- --         if self.模型 == '下固定' and 当前标识符 == self._动作标识符 then
    -- --             self:修改动作('下开炮')
    -- --             __rpc:角色_开炮(1, mnid)
    -- --         end
    -- --     end
    -- -- )
    -- self._定时动作3 = 引擎:定时(
    --     1000,
    --     function(ms)
    --         if self.模型 == '下开炮' and 当前标识符 == self._动作标识符 then
    --             self:修改动作('stand')
    --         end
    --     end
    -- )
end


return NPC
