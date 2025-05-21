
local 战斗_回合 = class('战斗_回合')

function 战斗_回合:初始化(回合数)
    self.回合底图 = __res:getspr('gires4/ty/bg_zhandou_huihe.tcp')
    self.回合精灵1 = __res.HHZ:置颜色(199, 252, 0):取精灵('第%s回合',
        string.rep(' ', #tostring(回合数)))
    self.回合精灵2 = __res.HHZ2:置颜色(255, 255, 0):取精灵(回合数)
end

function 战斗_回合:显示(x, y)
    self.回合底图:显示(10, 45)
    self.回合精灵1:显示(15, 50)
    self.回合精灵2:显示(40, 52)
end

return 战斗_回合
