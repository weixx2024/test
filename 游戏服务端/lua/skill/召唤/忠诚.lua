local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '忠诚',
    id = 304,
}


function 法术:回合开始(攻击方, 挨打方)
    local r = 攻击方:取主人()
    if r and not r.是否死亡 then
        local n = math.floor(攻击方.最大气血 * 0.05)
        r:增加气血(n)
    end
end

function 法术:法术取描述(P)
    return "忠心耿耿，至死不渝，为主人回复气血。#r#W【技能介绍】#r#G回合开始时为主人回复5%气血"
end

return 法术
