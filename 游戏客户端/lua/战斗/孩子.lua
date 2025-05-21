local 动作 = require('对象/基类/动作')
local 控制 = require('对象/基类/战斗控制')
local 状态 = require('对象/基类/状态')
local 数据 = require('战斗/基类/数据')
local 战斗孩子 = class('战斗孩子', 动作, 控制, 状态, 数据)
战斗孩子.模型表 = { 'guard', 'magic' }


function 战斗孩子:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end
    if not t.名称颜色 or t.名称颜色 == 0 then
        self.名称颜色 = 16711935
        self:置名称颜色(0, 255, 0, 255)
    end
    self:动作_防备()
end

function 战斗孩子:更新(dt)
    self[动作]:更新(dt)
    self[控制]:更新(dt)
    self[状态]:更新(dt)
    self[数据]:更新(dt)
end

function 战斗孩子:显示(xy)
    xy = self.xy
    self[状态]:显示底层(xy)
    self[数据]:显示底层(xy)
    self[动作]:显示(xy)
    self[状态]:显示名称(xy)
    self[状态]:显示(xy)
    self[数据]:显示(xy)
end

function 战斗孩子:显示顶层(xy)
    xy = self.xy
    self[状态]:显示顶层(xy)
    self[数据]:显示顶层(xy)
end

function 战斗孩子:取排序点()
    return self.xy.y
end

return 战斗孩子
