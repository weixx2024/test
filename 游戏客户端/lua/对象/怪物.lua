


local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/控制')
local 状态 = require('对象/基类/状态')
local 怪物 = class('怪物', 动作, 控制, 状态)
怪物.模型表 = { 'stand', 'walk' }

function 怪物:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    if not t.名称颜色 or t.名称颜色 == 0 then
        self:置名称颜色(0xFFFF00FF)
    end
    self.矩形 = require('SDL.矩形')(t.x, t.y, 30, 25):置中心(15, 20)
    self.已发送 = true
    self.外形 = __res:getshapeid(t.外形)
    -- self.是否NPC = true
end

function 怪物:更新(dt, xy)
    self[动作]:更新(dt)
    self[控制]:更新(dt, xy)
    self[状态]:更新(dt)

    if self.矩形:检查点(__rol.xy) then
        if not self.已发送 and (not __rol.是否组队 or __rol.是否队长) and not __rol.是否战斗 and
            not self.是否战斗 then
            __rol:停止移动()
            self.已发送 = true
            __rpc:角色_地图明雷(self.nid)
        end
    elseif self.已发送 then
        self.已发送 = false
    end
end

function 怪物:显示(xy)
    xy = self.xy - xy
    self[状态]:显示底层(xy) --状态
    self[动作]:显示(xy) --动作
    self[状态]:显示名称(xy)
    self[状态]:显示(xy) --状态
   -- self.矩形:显示(xy)
end

function 怪物:取排序点()
    return self.xy.y
end

function 怪物:消息事件(t)
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
            end
        end
    end
end

return 怪物
