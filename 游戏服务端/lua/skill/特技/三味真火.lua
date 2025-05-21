local 法术 = {
    类别 = '特技',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '三味真火',
    id = 503,
    是否物理法术 = true,
    是否仙法 = true
}

function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) <= self:取几率(攻击方) then
            攻击方.伤害 = self:法术取伤害(攻击方, 挨打方)
            挨打方:被法术攻击(攻击方, self)
            local dst = 攻击方:敌方属性排列(
                1,
                function(v)
                    if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') and 挨打方 ~= v then
                        return true
                    end
                end,
                function(a, b)
                    return a.速度 > b.速度 
                end
            )
            for i,v in pairs(dst) do
                攻击方.伤害 = self:法术取伤害(攻击方, v)
                v:被法术攻击(攻击方, self)    
            end
            return true
        end
    end
end


function 法术:法术基础伤害(攻击方)
    local 等级 = 攻击方.等级 + 1
    local 伤害 = 等级 * (47.4885 + 1.37058 * self.熟练度 ^ 0.4)
    return math.floor(伤害)
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = self:法术基础伤害(攻击方)
    伤害 = 取仙法伤害('火', 伤害, 攻击方, 挨打方)
    return math.floor(伤害)
end

function 法术:取目标数()
    return 2
end

function 法术:取几率(召唤)
    local ndjl = 10
    return ndjl
end

return 法术
