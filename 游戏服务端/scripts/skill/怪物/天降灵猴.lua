local 法术 = {
    类别 = '怪物',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '天降灵猴',
    是否被动 = true,
}

local BUFF
function 法术:进入战斗(自己)
    local b = 自己:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

BUFF = {
    法术 = '天降灵猴',
    名称 = '天降灵猴',
    银子 = 0
}
法术.BUFF = BUFF

function BUFF:物理攻击(攻击方, 挨打方)
    local 最小银子 = math.ceil(挨打方.银子 * 0.005)
    local 最大银子 = math.ceil(挨打方.银子 * 0.010)
    if 最大银子 > 2000000 then
        最大银子 = 2000000
    end

    local 扣除银子 = math.random(最小银子, 最大银子)
    if 挨打方.接口:扣除银子(扣除银子, '天降灵猴', false, nil, nil, true) then
        self.银子 = self.银子 + 扣除银子
        挨打方.当前数据:喊话(string.format('#Y偷取%s两银子', 扣除银子))
    end
end

return 法术
