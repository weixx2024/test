local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '高级奋蹄扬威',
    是否被动 = true,
}

function 法术:法术取描述(攻击方, 挨打方)
    return string.format("增加召唤兽自身忽视防御几率与忽视防御程度%s%%\n增加连击率、加成高级分裂攻击、分花拂柳几率%s%%",self:取效果(攻击方),self:取特殊效果(攻击方))
end

function 法术:取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    return math.floor(15 + SkillXS(qm,0.549))
end

function 法术:取特殊效果(P)
    local qm = P.亲密 or 0
    local 几率 = 5 + SkillXS(qm,0.28)
    return 几率
end

function 法术:计算_召唤(P)
    P.抗性.忽视防御程度 = P.抗性.忽视防御程度 + self:取效果(P)
    P.抗性.忽视防御几率 = P.抗性.忽视防御几率 + self:取效果(P)
    P.抗性.分裂攻击 = P.抗性.分裂攻击 + self:取特殊效果(P)
    P.抗性.分花几率 = P.抗性.分花几率 + 10
    P.抗性.连击率 = P.抗性.连击率 + self:取特殊效果(P)
end

return 法术
