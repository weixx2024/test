local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '仙风道骨',
    id = 2106,

}

function 法术:召唤进入战斗(攻击方,数据,目标)
    if 攻击方 and 攻击方.PK and 攻击方.战场.回合数 > 1 and 数据 then
        local dst = 攻击方:我方属性排序(
            1,
            function(v)
                if not v.是否死亡 and (not 目标 or 目标 ~= v )  and not v:取BUFF('封印') then
                    return true
                end
            end,
            function(a, b)
                -- return a.等级 > b.等级
                return a.气血 / a.最大气血 > b.气血 / b.最大气血
            end
        )
        local P = dst[1]
        if P then
            local 气血 = math.floor(P.最大气血 * 0.7)
            local 魔法 = math.floor(P.最大魔法 * 0.1)
            local 目标数据 = P.战场:指令开始()
            P:增标气血(气血)
            P:增加魔法(魔法,2)
            P.战场:指令结束()
            数据:法术后(目标数据)
        end
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "仙风道骨，卓尔不凡，为队友回复大量气血与少量法力#r#W【技能介绍】#r#G进场时（第一回合除外）回复气血百分比最低友方单位70%气血和10%法力。（仅玩家之间PK战斗有效）"
end


return 法术
