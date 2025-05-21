local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '测试技能',
    id = 803,
    是否仙法 = true
}

function 法术:法术施放(攻击方, 目标)
    self.xh = 0
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
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = 0
    伤害 = 999999999999
    return math.floor(伤害)
end

function 法术:取目标数()
    return 10
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取消耗()
    return { 消耗MP = 0 }
end

function 法术:法术取描述()
    return string.format('用龙召唤水攻击敌人#R%s#G人。',
        self:法术取目标数())
end

return 法术
