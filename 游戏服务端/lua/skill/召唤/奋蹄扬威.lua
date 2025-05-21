local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '奋蹄扬威',
    是否被动 = true,
}

function 法术:法术取描述(攻击方, 挨打方)
    local str = self:取效果(攻击方).."%"
    return string.format("增加召唤兽自身忽视防御几率与忽视防御程度%s",str)
end

function 法术:取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    return math.floor(10 + SkillXS(qm,0.349))

end

function 法术:计算_召唤(P)
    P.抗性.忽视防御程度 = P.抗性.忽视防御程度 + self:取效果(P)
    P.抗性.忽视防御几率 = P.抗性.忽视防御几率 + self:取效果(P)
end

return 法术
