local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '龙卷雨击',
    id = 801,
    是否仙法 = true
}

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        攻击方.伤害 = self:法术取伤害(攻击方, v)
        v:被法术攻击(攻击方, self)
    end
    if 攻击方.是否玩家 then
        self.熟练度 = self.熟练度 < self.熟练度上限 and self.熟练度 + 1 or self.熟练度上限
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
end

function 法术:法术基础伤害(攻击方)
    local 等级 = 攻击方.等级 + 1
    local 伤害 = 等级 * (35.9842 + 1.0387 * self.熟练度 ^ 0.4)
    return math.floor(伤害)
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = self:法术基础伤害(攻击方)
    伤害 = 取仙法伤害('水', 伤害, 攻击方, 挨打方)
    return math.floor(伤害)
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.107) }
end

function 法术:法术取描述()
    return string.format('用龙召唤水攻击敌人#R%s#G人。',
        self:法术取目标数())
end

return 法术
