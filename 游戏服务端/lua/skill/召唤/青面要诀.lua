local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '青面要诀',
    是否被动 = true,
}

function 法术:法术取描述(攻击方, 挨打方)
    return "进阶要诀，青面要诀。#r#W【技能介绍】#r#G增强使用青面獠牙时对目标的伤害#r#R17552"
end

function 法术:取效果(P)
    
end

function 法术:计算_召唤(P)
    P.抗性.青面要诀 = P.抗性.青面要诀 + 17552
end
return 法术
