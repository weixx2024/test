local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '遗产',
    id = 304,

}

function 法术:召唤离场(攻击方,数据)
    local dst = 攻击方:我方属性排序(
        1,
        function(v)
            if not v.是否死亡 and (not 攻击方 or 攻击方 ~= v )  and not v:取BUFF('封印') then
                return true
            end
        end,
        function(a, b)
            return a.魔法 / a.最大魔法 > b.魔法 / b.最大魔法
        end
    )
    local P = dst[1]
    if P then
        local 魔法 = math.floor(攻击方.魔法 * 2)
        P:增加魔法(魔法,2)
    end
    
    -- end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "落红不是无情物，化作春泥更护花，死亡时为己方留下丰厚的遗产。#r【消耗MP】0#r#G离场时将自身法力按照百分比的2倍留给己方法力最低人物."
end

return 法术
