-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 00:49:34
local 物品 = {
    名称 = '隐身药',
    叠加 = 999,
    类别 = 1,
    类型 = 1,
    对象 = 12,
    条件 = 63,
    绑定 = false,
    排序 = 100
}

local BUFF
BUFF = {
    法术 = '隐身',
    名称 = '隐身',
    id = '隐身'
}

function BUFF:BUFF添加后(buff, 目标)
    if self == buff then

    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.是否隐身 = false
    end
end

function BUFF:BUFF物理攻击(P)
    P:删除BUFF('隐身')
    P.是否隐身 = false
end

function BUFF:法术施放前(P)
    P:删除BUFF('隐身')
    P.是否隐身 = false
end

function BUFF:BUFF物品使用前(单位, 挨打方)
    单位:删除BUFF('隐身')
    单位.是否隐身 = false
end

function 物品:使用(对象, 来源)
    if 对象.是否战斗 or 对象.取主人 or 对象.是否怪物 then
        local b = 对象:进入添加BUFF(BUFF)
        b.回合 = 3
        来源.当前数据:添加BUFF("隐身",对象.位置)
        来源.当前数据.位置 = 对象.位置
        对象.是否隐身 = true
        self.数量 = self.数量 - 1
    end
end

return 物品
