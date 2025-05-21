local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '高级分裂攻击',
    是否被动 = true,
}


function 法术:计算_召唤(P)
    P.抗性.分裂攻击 = P.抗性.分裂攻击 + self:取几率(P)
end

function 法术:取几率(攻击方,挨打方)
    local qm = 攻击方.亲密 or 0
    return math.floor(10 + SkillXS(qm,0.2))
end


function 法术:法术取描述(攻击方, 挨打方)
    return string.format("分身有术，幻化千影，增加攻目标，令对方防不胜防。#r#W【技能介绍】#r#G物理攻击时有%s%%几率增加一个目标",攻击方.抗性.分裂攻击)
end

return 法术
