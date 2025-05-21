local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '高级倍道兼行',
    是否被动 = true,
}

function 法术:法术取描述(攻击方, 挨打方)
    return string.format("日夜不处，倍道兼行，提升速度。#r#W【技能介绍】#r#G增加召唤兽SP#r#R%s",self:取效果(攻击方))
end

function 法术:取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    local dj = 攻击方.等级
    local zs = 攻击方.转生
    return 180 + SkillXS(qm,1.42) + dj * 0.2 + zs * 3
end


function 法术:计算_召唤(P)
    if not P:取技能是否存在("潮鸣电掣") and not P:取技能是否存在('神出鬼没') then
        P.速度 = P.速度 + self:取效果(P)
    end
end

return 法术
