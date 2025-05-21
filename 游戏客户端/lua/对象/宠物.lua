

local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/控制')
local 状态 = require('对象/基类/状态')

local 宠物 = class('宠物', 动作, 控制, 状态)
宠物.模型表 = {'stand', 'walk', 'run'}

function 宠物:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    if not t.名称颜色 or t.名称颜色 == 0 then
        self:置名称颜色(0xFFAF75FF)
    end
    self.移动速度 = 150

end

function 宠物:更新(dt, xy, sxy)
    self[动作]:更新(dt)
    self[控制]:更新(dt, xy)
    self[状态]:更新(dt)
end

function 宠物:显示(xy)
    xy = self.xy - xy
    self[状态]:显示底层(xy)
    self[动作]:显示(xy)
    self[状态]:显示名称(xy)
    self[状态]:显示(xy)
end

function 宠物:取排序点()
    return self.xy.y
end

return 宠物
