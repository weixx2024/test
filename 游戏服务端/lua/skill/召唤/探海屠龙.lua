local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '探海屠龙',
	是否终极 = true,
    id = 2138,
}


function 法术:禁止保护(攻击方)
    if self:取几率() >= math.random(100) then
        return true
    end
    return false
end

function 法术:取几率()
    return 40 + SkillXS(qm,0.5)
end

function 法术:法术取描述(攻击方, 挨打方)
    return "有几率直接忽视敌方的保护状态 "
end

return 法术
