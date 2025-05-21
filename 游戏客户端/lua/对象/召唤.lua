

local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/控制')
local 状态 = require('对象/基类/状态')

local 召唤 = class('召唤', 动作, 控制, 状态)
召唤.模型表 = { 'stand', 'walk', 'run' }

function 召唤:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    if not t.名称颜色 or t.名称颜色 == 0 then
        self:置名称颜色(0xFFAF75FF)
    end
    self.移动速度 = 200
end

function 召唤:更新(dt, xy, sxy)
    self[动作]:更新(dt)
    self[控制]:更新(dt, xy)
    self[状态]:更新(dt)
end

function 召唤:显示(xy)
    xy = self.xy - xy
    self[状态]:显示底层(xy)
    self[动作]:显示(xy)
    self[状态]:显示名称(xy)
    self[状态]:显示(xy)
end

function 召唤:取排序点()
    return self.xy.y
end

return 召唤
