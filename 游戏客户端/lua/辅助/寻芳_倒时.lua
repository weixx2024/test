

local 数字精灵 = require('辅助/精灵_数字')

local d = __res:getspr('gires3/other/djstx/dd.tcp'):置中心(0, -60)
local g = __res:getspr('gires3/other/djstx/gg.tcp'):置中心(-83, -60)
--local s =
local dd = __res:getspr('gires3/other/djstx/mh.tcp') --:置中心( - 75)
local 副本倒时 = class('副本倒时', 数字精灵)

function 副本倒时:初始化(n)
    --  n = 1800
    self:数字精灵('gires3/other/djstx/%d.tcp', n)
    self.n = n or 60
    self.dt = 0
    self._py = 0
    self._gpx = 0
    self._gpy = 0
    self._gpx2 = 0
    self._gpy2 = 0
    self.关 = {}
end

function 副本倒时:更新(dt)
    if self.n >= 0 then
        self.dt = self.dt + dt
        if self.dt >= 1 then
            self.dt = 0
            self.n = self.n - 1
            self:置数字(self.n)
        end
    end
end

function 副本倒时:显示(x, y)
    if self.n >= 0 then --h
        d:显示(x, y)

        if self.关[1] then
            self.关[1]:显示(x + self._gpx, y + self._gpy)
        end
        if self.关[2] then
            self.关[2]:显示(x + self._gpx2 + self._py, y + self._gpy2)
        end

        g:显示(x + self._py, y)
        dd:显示(x + 190 + self._py, y + 103)
        dd:显示(x + 190 + 60 + self._py, y + 103)
        self[数字精灵]:显示(x + 145 + self._py, y + 103)
    end
end

function 副本倒时:置数字(n)
    if type(n) == 'number' then
        self.n = n
        if n >= 0 then
            self[数字精灵]:置数字2(n)
        end
    else
        self[数字精灵]:置数字2(n)
    end
    return self
end

local _转换 = {

    "一", "二", "三", "四", "五", "六", "七", "八", "九", "十",



}

local _py = {

    { 40, 75 },
    { 35, 70 },
    { 37, 63 },
    { 37, 70 },
    { 35, 63 },
    { 35, 63 },
    { 35, 63 },
    { 35, 75 },
    { 35, 63 },
    { 35, 60 },
}

function 副本倒时:置关卡(关, 时间)
    self.关 = {}
    self._py = 0
    self._gpx = 0
    self._gpy = 0

    if 关 > 10 then
        local s
        local t
        self._gpx = 35
        self._gpy = 60
        table.insert(self.关, __res:getspr('gires3/other/djstx/110.tcp'):置中心(0, 0)) --:置中心(-40, -75))
        s = 关 % 10
        t = _py[关 % 10]
        if s then
            self._gpx2 = t[1]
            self._gpy2 = t[2]
            self._py = self._py + 50
            table.insert(self.关, __res:getspr('gires3/other/djstx/%s.tcp', s + 100):置中心(0, 0)) --:置中心(-40, -75))
        end
    else

        local t = _py[关]
        self._gpx = t[1]
        self._gpy = t[2]
        table.insert(self.关, __res:getspr('gires3/other/djstx/%s.tcp', 关 + 100):置中心(0, 0))

    end
    if 时间 then
        self:置数字(时间)
    end

end

return 副本倒时
