

local 战斗怨怒 = class('战斗怨怒')

function 战斗怨怒:初始化()
    self.怒底 = __res:getspr('gires3/other/nq.tcp')
    self.怨底 = __res:getspr('gires3/other/yq.tcp'):置中心(60, 0)
    self.怒气 = __res.F12B:置颜色(211,190,152):取精灵('0')
    self.怨气 = __res.F12B:置颜色(186, 142, 188):取精灵('149')

end

function 战斗怨怒:显示(x, y)
    self.怒底:显示(x, y)
    self.怨底:显示(x, y)
    self.怨气:显示(x - 35, y + 6)
    self.怒气:显示(x + 30, y + 6)
end

function 战斗怨怒:置怒气(v)
    self.怒气 = __res.F12B:置颜色(211,190,152):取精灵(v)
end

function 战斗怨怒:置怨气(v)
    self.怨气 = __res.F12B:置颜色(186,142,188):取精灵(v)
end

return 战斗怨怒
