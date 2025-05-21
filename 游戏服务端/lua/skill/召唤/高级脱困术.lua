local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '高级脱困术',
    id = 304,

}

function 法术:回合开始(攻击方, 挨打方)
    if 攻击方:取BUFF('封印') then
        local 几率 = self:取几率(攻击方, 挨打方)
        if 几率 > math.random(100) then
            攻击方:添加特效(2115)
            攻击方:删除BUFF('封印')
        end
    end
end

function 法术:取几率(攻击方, 挨打方)
    local qm = 攻击方.亲密 or 0
    return math.floor(30 + qm*0.004)
end

function 法术:法术取描述(P)
    return string.format("轻轻松松，脱困成功，领自己白摆脱封印。#r#W【技能介绍】#r#G回合开始时有几率摆脱封印状态",self:取几率(P))
end

return 法术
