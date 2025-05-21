local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '太乙生风',
    id = 703,
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
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
    if 攻击方.是否玩家 then
        self.熟练度 = self.熟练度 < self.熟练度上限 and self.熟练度 + 1 or self.熟练度上限
    end
end

function 法术:法术基础伤害(攻击方)
    local 等级 = 攻击方.等级 + 1
    local 伤害 = 等级 * (47.4885 + 1.37058 * self.熟练度 ^ 0.4)
    return math.floor(伤害)
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = self:法术基础伤害(攻击方)
    伤害 = 取仙法伤害('风', 伤害, 攻击方, 挨打方)

    return math.floor(伤害)
end

function 法术:取目标数(攻击方)
    if self.熟练度 >= 16610 then
        return 5
    elseif self.熟练度 >= 5215 then
        return 4
    elseif self.熟练度 >= 720 then
        return 3
    else
        if 攻击方 and 攻击方.外形 == 2167 then
            return 3
        end
        return 2
    end
end

function 法术:法术取目标数(攻击方)
    return self:取目标数(攻击方), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.178) }
end

function 法术:法术取描述(攻击方)
    return string.format('用狂风产生的能里攻击#R%s#G人。',
        self:法术取目标数(攻击方))
end

return 法术
