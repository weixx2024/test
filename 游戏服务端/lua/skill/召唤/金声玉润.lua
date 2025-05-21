local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '金声玉润',
    是否被动 = true,
}


function 法术:受到伤害前(攻击方, 挨打方) --75 满级
    if 攻击方.伤害 >= 0 and 攻击方.金 > 50  then
        local xs = self:法术取效果(挨打方)
        攻击方.伤害 = math.floor(攻击方.伤害 * (1-xs))
    end
end

function 法术:法术取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    return (5 + SkillXS(qm,0.1))/100
end


function 法术:法术取描述(攻击方, 挨打方)
    return string.format("若对方金五行≥50，则对自己造成的伤害减少%s%%。领悟该技能需金五行≥50。",self:法术取效果(攻击方))
end

return 法术
