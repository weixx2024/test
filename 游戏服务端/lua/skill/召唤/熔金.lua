local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '熔金',
	是否终极 = true,
    id = 2138,
}

function 法术:召唤进入战斗(攻击方,数据,召唤,闪现)
    local dst = 攻击方:所满足对象(
        function(v)
            if not v.是否死亡 and not 召唤:是否我方(v) and v.是否召唤 and v.金 >= 50  then
                return true
            end
        end
    )
    if #dst > 0 then
        local 临时数据 = 攻击方.战场:指令开始()
        for i,v in ipairs(dst) do
            召唤.伤害 = (math.floor(v.气血*0.05))
            v:被法术攻击(召唤,self)
        end
        攻击方.战场:指令结束()
        数据:法术后(临时数据)
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "进场时对所有金属性大于或等于50的敌方召唤兽造成伤害（第一回合除外）  "
end

return 法术
