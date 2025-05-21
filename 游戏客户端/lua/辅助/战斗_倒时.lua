

local 数字精灵 = require('辅助/精灵_数字')
local wait = __res:getspr('misc/war/wait.png'):置中心(100, 0)

local 战斗倒时 = class('战斗倒时', 数字精灵)

function 战斗倒时:初始化(n)
    self:数字精灵('misc/war/%d.tcp', n , 1)
    self.n = n or 0
    self.dt = 0
end

function 战斗倒时:更新(dt)
    if self.n >= 0 then
        self.dt = self.dt + dt
        if self.dt >= 1 then
            self.dt = 0
            self.n = self.n - 1
            self:置数字(self.n)
        end
    end
end

function 战斗倒时:显示(x, y)
    if self.n >= 0 then
        self[数字精灵]:显示(x, y)
    elseif self.n == -1 then
        wait:显示(x, y)
    end
end

function 战斗倒时:置数字(n)
    if type(n) == 'number' then
        self.n = n
        if n >= 0 then
            self[数字精灵]:置数字(n)
        end
    else
        self[数字精灵]:置数字(n)
    end
    return self
end
return 战斗倒时
