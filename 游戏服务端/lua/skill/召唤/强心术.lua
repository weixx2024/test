local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '强心术',
    id = 304,

}

function 法术:回合开始(攻击方)
    if 攻击方:取BUFF('遗忘') and not 攻击方:取技能是否存在('高级强心术') then
        local 几率 = self:取几率(攻击方)
        if 几率 > math.random(100) then
            攻击方:添加特效(2116)
            攻击方:删除BUFF('遗忘')
        end
    end
end

function 法术:取几率(攻击方)
    local qm = 攻击方.亲密 or 0
    return math.floor(10 + qm*0.002)
end

function 法术:法术取描述(P)
    return string.format("神思清明，不再为对手所惑，令自己白摆脱遗忘。#r#W【技能介绍】#r#G回合开始时有%s%%几率摆脱遗忘状态",self:取几率(P))
end

return 法术
