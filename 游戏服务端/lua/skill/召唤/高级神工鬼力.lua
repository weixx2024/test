-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-08-31 09:29:46
-- @Last Modified time  : 2024-09-12 22:32:20

local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '高级神工鬼力',
    是否被动 = true,
}


function 法术:法术取描述(P)
    return string.format("上天赋予的神之源力，能发出强大的攻击力。#r#W【技能介绍】#r#G增加召唤兽AP#r#R%s。",self:取效果(P))
end

function 法术:取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    local dj = 攻击方.等级
    local zs = 攻击方.转生
    return 4228 + SkillXS(qm,390) + dj * 30 + zs * 200
end

function 法术:计算_召唤(P)
    if  not P:取技能是否存在('神工鬼力') then 
       P.攻击 = P.攻击 + self:取效果(P)
    end   
end

return 法术
