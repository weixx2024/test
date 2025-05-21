local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '慈乌反哺',
    是否被动 = true,
}

function 法术:物理攻击后(攻击方, 挨打方,数据,伤害)
    if self:取机率(攻击方) > math.random(100) then
        local 主人 = 攻击方:取主人()
        local 亲密 = 攻击方.亲密
        local 效果 = self:法术取效果(攻击方)
        local 气血 = math.floor(伤害 * 效果/100)
        if 主人 then
            主人:增加气血(气血)
            主人.当前数据.位置 = 主人.位置
        end
    end
end

function 法术:取机率(攻击方)
    local qm = 攻击方.亲密 or 0
    return math.floor(15 + SkillXS(qm,0.1))
end

function 法术:法术取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    return 15
end


function 法术:法术取描述(攻击方, 挨打方)
    local str = self:取机率(攻击方) .. "%"
    local str1 = self:法术取效果(攻击方) .. "%"
    return string.format("昔日老鸦护雏，今日慈鸟反哺，善待宝宝得到孝心回报，宝宝将攻击别人的伤害化为气血反哺主人。#r#W【技能介绍】#r#G物理攻击时有%s几率将物理伤害%s转化为主人的气血",str,str1)
end

return 法术
