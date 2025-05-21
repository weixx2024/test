local 法术 = {
    类别 = '属性',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '附水攻击',
    id = 804,
    是否物理法术 = true,
}
function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        攻击方.伤害 = self:取伤害(攻击方, 挨打方)
        挨打方:被法术攻击(攻击方, self)
        return true
    end
end

function 法术:是否触发(攻击方, 挨打方)
    if math.random(100) <= 攻击方.附水攻击 then
        return true
    end
end

function 法术:取伤害(攻击方, 挨打方)
    local 伤害 = 0
    local 等级 = 攻击方.等级 + 1
    伤害 = 等级 * (64.98918 + 2.03423 * 1 ^ 0.4)
    伤害 = 伤害 * (1 + (攻击方.加强水 - 挨打方.抗水 + 攻击方.忽视抗水) * 0.01)
    伤害 = 强克伤害加成(攻击方, 挨打方, 伤害)
    if 伤害 <= 0 then
        伤害 = 1
    end
    return math.floor(伤害)
end

return 法术
