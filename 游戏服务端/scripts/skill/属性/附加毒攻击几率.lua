local 法术 = {
    类别 = '属性',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '附加毒攻击几率',
    id = 104,
    是否物理法术 = true,
}

local BUFF

function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        local n = self:取伤害(攻击方, 挨打方)
        攻击方.伤害 = n
        挨打方:被法术攻击(攻击方, self)
        local b = 挨打方:添加BUFF(BUFF)
        if b then
            b.回合 = 3
            b.毒伤害 = n
        end
        return true
    end
end

function 法术:是否触发(攻击方, 挨打方)
    if math.random(100) <= 攻击方.附加毒攻击几率 then
        return true
    end
end

function 法术:取伤害(攻击方, 挨打方)
    local 伤害 = 0
    local 等级 = 攻击方.等级
    伤害 = 等级 * (2.02312 * 1 ^ 0.4)
    伤害 = 伤害 * (1 + 攻击方.忽视抗毒 * 0.01 - 挨打方.抗中毒 * 0.01)
    伤害 = 强克伤害加成(攻击方, 挨打方, 伤害)
    伤害 = 伤害 * (1 + 攻击方.加强毒 / 100) + 攻击方.加强毒伤害 - 挨打方.抗毒伤害
    return math.floor(伤害)
end

BUFF = {
    法术 = '鹤顶红粉',
    名称 = '中毒',
    id = 104
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('昏睡')
    end
end

function BUFF:BUFF回合开始(目标)
    目标:减少气血(self.毒伤害)
    self.毒伤害 = math.floor(self.毒伤害 * 0.75)
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
