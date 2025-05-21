local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '怒仙',
    id = 304,

}

function 法术:计算_召唤(P)
    if P.接口 and P.接口.取内丹是否存在 and P.接口:取内丹是否存在("红颜白发") then
        local 亲密度 = P.亲密 or 0
        local n = math.floor(亲密度 ^ 0.205)
        P.抗性.水系狂暴几率 = math.floor(P.抗性.水系狂暴几率 + n)
        P.抗性.火系狂暴几率 = math.floor(P.抗性.火系狂暴几率 + n)
        P.抗性.雷系狂暴几率 = math.floor(P.抗性.雷系狂暴几率 + n)
        P.抗性.风系狂暴几率 = math.floor(P.抗性.风系狂暴几率 + n)
        P.抗性.鬼火狂暴几率 = math.floor(P.抗性.鬼火狂暴几率 + n)
    end
end

function 法术:法术取描述(P)
    local 亲密度 = P.亲密 or 0
    local n = math.floor(亲密度 ^ 0.205)
    return string.format("仙道无情，一怒万钧。#r#W【技能介绍】#r#G增加仙法鬼火狂暴几率%s%%（需配合内丹“红颜白发”一同使用才能发挥作用。）"
        , n)
end

return 法术
