local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '自医',
    id = 304,

}



function 法术:回合开始(攻击方, 挨打方)
    if math.floor(攻击方.最大气血 * 0.3) > 攻击方.气血 then
        local 几率 = self:取几率(攻击方, 挨打方)
        if 几率 > math.random(100) then
            local hp = math.floor(攻击方.最大气血 * 0.5)
            攻击方:增加气血(hp)
        end
    end
end

function 法术:取几率(攻击方, 挨打方)
    local 亲密度 = 攻击方.亲密 or 0
    local 几率 = 10 + math.floor(亲密度 ^ 0.17) 
    return 几率
end

function 法术:法术取描述(P)
    local 几率 = self:取几率(P)

    return string.format("万物有灵，伤者自医，回复自身气血。#r#W【技能介绍】#r#G回合开始时如果自身血量低于30%%，有%s几率自我恢复50%%血量",几率.."%")
end

return 法术
