local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '高级帐饮东都',
    是否被动 = true,
}


function 法术:法术取描述(P)
    return string.format("畅饮东都，送客金谷，离别催人泪，情话心头血，气血大增#r#W【技能介绍】#r#G增加召唤兽HP上限#r#R%s%%",self:取效果(P))
end

function 法术:取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    local dj = 攻击方.等级
    local zs = 攻击方.转生
    return 20000 + SkillXS(qm,519) + dj * 70 + zs * 1000
end

function 法术:计算_召唤(P)
    P.最大气血=P.最大气血+self:取效果(P)
end

return 法术
