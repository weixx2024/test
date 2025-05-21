local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '天地同寿',
    id = 2118,

}



function 法术:召唤离场(自己,数据,攻击方)
    if self:取几率(自己) > math.random(100) and 自己.是否PK then
        local dst = 自己:随机敌方(
            1,
            function(v)
                if v.位置 ~= 攻击方.位置 and v.外形 == 自己.外形  then
                    return true
                end
            end--,
        )
        local P = dst[1]
        if P then
            P:被驱逐(2118,数据)
        end
    end
end

function 法术:取几率(召唤)
    local qm = 召唤.亲密
    return math.floor(30 + SkillXS(qm,0.87))
end
function 法术:法术取描述(攻击方, 挨打方)
    return string.format("召唤兽离场时有%s%%随机带走一只与自己造型相同的敌方召唤兽。",self:取几率(攻击方))
end

return 法术
