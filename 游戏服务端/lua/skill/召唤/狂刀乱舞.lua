local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '狂刀乱舞',
    是否被动 = true,
}
function 法术:物理攻击(攻击方,挨打方,数据)
    local 几率 = self:取几率(攻击方, 挨打方)
    if 几率 > math.random(10) then
        local dst = 攻击方:随机敌方(
            3,
            function(v)
                if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') and (not 挨打方 or 挨打方 ~= v ) then
                    return true
                end
            end
        )
        for i,v in pairs(dst) do
            攻击方.伤害 = math.floor(攻击方.伤害)
            if 攻击方.伤害 < 1 then
                攻击方.伤害 = 1
            end
            v:被物理攻击(攻击方)
        end
        攻击方:当前喊话("狂刀乱舞，杀")
    end
end

function 法术:法术取描述(P)
    return string.format("刀法极高，常常一刀之中砍到多个目标。")
end

function 法术:取几率(攻击方, 挨打方)
    local 亲密度 = 攻击方.亲密 or 0
    local 几率 = 10 + math.floor(亲密度 ^ 0.17)
    return 几率
end

return 法术
