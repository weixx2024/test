local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '日月重光',


}
function 法术:计算_召唤(P)
    P.抗性.抗封印 = P.抗性.抗封印 + self:法术取效果(P)
    P.抗性.抗混乱 = P.抗性.抗混乱 + self:法术取效果(P)
    P.抗性.抗遗忘 = P.抗性.抗遗忘 + self:法术取效果(P)
end

function 法术:法术取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    return math.floor(11 + SkillXS(qm,0.1))
end

function 法术:法术取描述(P)
    return string.format("得天地之精华，提升自身抗性。#r#W【技能介绍】#r#G提高自身冰混忘抗性s%%",self:法术取效果(P))
end

return 法术
