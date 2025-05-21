local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '源泉万斛',
    是否被动 = true,
}

function 法术:法术取描述(P)
    return string.format("万斛泉源喷涌而出，用才思瞬间提升灵气，法力大增。#r#W【技能介绍】#r#G增加召唤兽MP上限#r#R%s%%",self:取效果(P))
end

function 法术:取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    local dj = 攻击方.等级
    local zs = 攻击方.转生
    return 13598 + SkillXS(qm,519) + dj * 50 + zs * 500
end

function 法术:计算_召唤(P)
    if  not P:取技能是否存在('高级源泉万斛') then
        P.最大魔法=P.最大魔法+self:取效果(P)
    end
end


return 法术
