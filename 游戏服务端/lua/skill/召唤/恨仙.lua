-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-09-28 18:34:50
-- @Last Modified time  : 2024-09-28 22:26:45

local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '恨仙',


}

function 法术:计算_召唤(P)
    --内丹是否存在开天辟地
    if P.接口 and P.接口.取内丹是否存在 and P.接口:取内丹是否存在("开天辟地") then
        local n = self:取效果(P)
        P.抗性.忽视抗水 = math.floor(P.抗性.忽视抗水 + n)
        P.抗性.忽视抗火 = math.floor(P.抗性.忽视抗火 + n)
        P.抗性.忽视抗雷 = math.floor(P.抗性.忽视抗雷 + n)
        P.抗性.忽视抗风 = math.floor(P.抗性.忽视抗风 + n)
        P.抗性.忽视抗鬼火 = math.floor(P.抗性.忽视抗鬼火 + n)
    end
end

function 法术:取效果(P)
    local 亲密度 = P.亲密 or 0
    local n = 10 + math.floor(亲密度 ^ 0.157)
    return n
end

function 法术:法术取描述(P)
    local n self:取效果(P)
    return string.format("仙道无情，一恨千古。#r#W【技能介绍】#r#G增加忽视仙法鬼火抗性s%%（需配合内丹“开天辟地”一同使用才能发挥作用。）", n)
end






return 法术
