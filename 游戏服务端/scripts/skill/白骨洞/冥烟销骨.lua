local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '冥烟销骨',
    是否鬼法 = true,
    id   = 1803,
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
        self.xh=false
    end
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = 0
    local 等级 = 攻击方.等级 + 1
    伤害 = 等级 * (47.4885 + 1.37058 * self.熟练度 ^ 0.4) * 0.66
    local r = 攻击方:取我方玩家倒地数量()
    if r > 0 then
        伤害 = 伤害 * 1.5
        伤害 = 伤害 + r * 4000 - 4000
    end
    伤害 = 取鬼法伤害(攻击方, 挨打方, 伤害)
    --水系吸收 *0.8  玄冰甲*0.5
    if math.random(100) < 攻击方.鬼火狂暴几率 - 挨打方.抗鬼火狂暴率 then
        伤害 = 伤害 * (1.5 + 攻击方.鬼火狂暴程度 * 0.01)
        挨打方.伤害类型 = "狂暴"
    end

    if 伤害 <= 0 then
        伤害 = 1
    end
    return math.floor(伤害)
end

function 法术:取目标数()
    if self.熟练度 >= 16610 then
        return 5
    elseif self.熟练度 >= 5215 then
        return 4
    elseif self.熟练度 >= 720 then
        return 3
    else
        return 2
    end
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.178) }
end

function 法术:法术取描述()
    return string.format('缕缕青烟,销去的不仅是对方的躯体，灵魂将被一同焚燃,己方到地人数越多威力越强，目标人数#R%s#G人。',self:法术取目标数())
end

return 法术