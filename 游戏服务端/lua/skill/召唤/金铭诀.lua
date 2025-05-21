local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '金铭诀',
    id = 304,

}

function 法术:计算_召唤(P)
    P.金 = math.floor(P.金 * 0.5)
    P.木 = math.floor(P.木 * 0.5)
    P.水 = math.floor(P.水 * 0.5)
    P.火 = math.floor(P.火 * 0.5)
    P.土 = math.floor(P.土 * 0.5)

    P.金 = P.金 + 50
    P.抗性.抗封印 = P.抗性.抗封印 + self:法术取效果(P)
    P.抗性.抗混乱 = P.抗性.抗混乱 + self:法术取效果(P)
    P.抗性.抗遗忘 = P.抗性.抗遗忘 + self:法术取效果(P)
end

function 法术:法术取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    return math.floor(8 + SkillXS(qm,0.1))
end

function 法术:法术取描述(P)
    return string.format("五色之中，黄为之长，久埋不生衣，百炼不轻，自身能力得到提升。#r#W【技能介绍】#r#G提高自身金五行50和冰混忘抗性%s",self:法术取效果(P))
end




return 法术
