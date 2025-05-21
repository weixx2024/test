-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-09-28 18:34:50
-- @Last Modified time  : 2024-10-25 19:59:52

local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '画魂叠影',
    是否被动 = true,
}

function 法术:法术取描述(攻击方, 挨打方)
    return string.format("增加连击率、加成高级分裂攻击、分花拂柳几率%s%%",self:取效果(攻击方))
end

function 法术:取效果(P)
    local qm = P.亲密 or 0
    local 几率 = 5 + SkillXS(qm,0.28)
    return 几率
end

function 法术:计算_召唤(P)
    if P:取技能是否存在("分花拂柳") then
        P.抗性.分花几率 = P.抗性.分花几率 + 10
    end
    if P:取技能是否存在("高级分裂攻击") or P:取技能是否存在("分裂攻击") then
        P.抗性.分裂攻击 = P.抗性.分裂攻击 + self:取效果(P)
    end
    P.抗性.连击率 = P.抗性.连击率 + self:取效果(P)
end

return 法术
