local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/控制')

local 神行 = class('神行', 动作, 控制)
神行.模型表 = { 'stand', 'walk', 'run', } --'stand2'

function 神行:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end

    self:置透明(true, 0)
end

function 神行:更新(dt, xy, sxy)
    self[动作]:更新(dt)
    self[控制]:更新(dt, xy)
end

function 神行:显示(xy)
    xy = self.xy - xy
    self[动作]:显示(xy)
end

function 神行:取排序点()
    return self.xy.y
end

return 神行
