local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '礼之火叶神',
	id = 2113,
}

function 法术:取效果(攻击方)
    -- local qm = 攻击方.亲密 or 0
    -- local dj = 攻击方.等级
    -- local zs = 攻击方.转生
    --2423 + SkillXS(qm,390) + dj * 20 + zs * 100
    return 15
end


function 法术:计算_召唤(P)
    P.抗性.抗封印 = P.抗性.抗封印 + self:取效果(P)
    P.抗性.抗混乱 = P.抗性.抗混乱 + self:取效果(P)
    P.抗性.抗遗忘 = P.抗性.抗遗忘 + self:取效果(P)
end


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
    return string.format("有几率无需召唤自动加入战斗，提高冰混遗忘抗性#r#R%s%%,离场时将自身法量按照百分比的2倍遗留给己方法量最低人物！",self:取效果(攻击方))
end



return 法术
