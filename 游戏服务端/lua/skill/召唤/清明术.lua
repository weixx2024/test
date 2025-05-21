local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '清明术',
    id = 304,

}





function 法术:回合开始(攻击方, 挨打方)
    if 攻击方:取BUFF('混乱')  and not 攻击方:取技能是否存在('高级清明术') then
        local 几率 = self:取几率(攻击方, 挨打方)
        if 几率 > math.random(100) then
            攻击方:添加特效(2114)
            攻击方:删除BUFF('混乱')
        end
    end
end

function 法术:取几率(攻击方)
    local qm = 攻击方.亲密 or 0
    return math.floor(10 + qm*0.002)
end

function 法术:法术取描述(P)
    return string.format("本来无一物，何处惹尘埃，灵台一点尽空明，令自己摆脱混乱。#r【消耗MP】0#r#G回合开始时有几率摆脱混乱状态",self:取几率(P))
end

return 法术
