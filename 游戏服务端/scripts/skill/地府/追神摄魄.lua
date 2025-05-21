local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '追神摄魄',
    id = 1202,
}

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        攻击方.伤害, 攻击方.魔法伤害 = self:法术取伤害(攻击方, v)
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

function 法术:法术取伤害(攻击方, 挨打方)
    local 震慑 = self:取HP伤害()
    local 扣蓝 = self:取MP伤害()
    扣蓝 = math.floor(扣蓝 * 0.01 * 挨打方.魔法)
    if 挨打方.抗震慑魔法 and 挨打方.抗震慑魔法 > 0 then
        扣蓝 = math.floor(扣蓝*挨打方.抗震慑魔法/100)
    end--就这5个技能吧 是
    local 伤害 = 取震慑伤害(震慑, 攻击方, 挨打方)

    return 伤害, 扣蓝
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.143) }
end

function 法术:取HP伤害()
    local n = math.floor((10 + self.熟练度 ^ 0.3295) * 100) * 0.01
    if n > 33 then
        n = 33
    end
    return n
end

function 法术:取MP伤害()
    local n = math.floor((10 + self.熟练度 ^ 0.31) * 100) * 0.01
    if n > 42 then
        n = 42
    end
    return n
end

function 法术:法术取描述()
    return string.format('减少敌人HP当前#R%s#G和MP当前#R%s#G，使用效果为#R%s#G人。', self:取HP伤害()
        .. "%",
        self:取MP伤害() .. "%", self:法术取目标数())
end

return 法术
