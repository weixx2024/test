local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '灵逸',
    id = 304,

}


function 法术:回合开始(攻击方)
    if not 攻击方:取BUFF("封印") then
        local r = 攻击方:取主人()
        if r and not r.是否死亡 then
            r:增加怨气(20, true)
            r.rpc:刷新怨气(r.怨气)
        end
    end
end

function 法术:法术取描述(P)
    return string.format("#W【技能介绍】#r#G回合开始时为主人回复20怨气")
end

return 法术
