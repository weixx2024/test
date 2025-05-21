local 法术 = {
    类别 = '属性',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '火法反击',
    id = 504,
    -- 是否被动 = true,
}


function 法术:法术反击(攻击方, 挨打方)
    if 挨打方 then
        local 伤害 = 0
        local 等级 = 攻击方.等级 + 1
        伤害 = 等级 * (64.98918 + 2.03423 * 1 ^ 0.4)
        攻击方.伤害 = math.floor(伤害)

    end
end

function 法术:是否触发(攻击方, 挨打方)
    if math.random(100) <= 挨打方.火法反击 and not 挨打方.是否死亡 then
        return true
    end
end

return 法术
