local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '潮鸣电挚',
    是否被动 = true,
}

function 法术:计算_召唤(P)
    local sp = math.floor(P.亲密 ^ 0.3347)
    P.速度 = P.速度 + self:法术取效果(P)
end

function 法术:法术取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    return math.floor(200 + SkillXS(qm,0.3347))
end

function 法术:法术取描述(P)
    return string.format('增加召唤兽SP%s',self:法术取效果(P))
end

return 法术
