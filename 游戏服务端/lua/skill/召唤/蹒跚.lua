local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '蹒跚',
    id = 304,

}


function 法术:计算_召唤(P)
    local 亲密 = P.亲密 or 0
    P.速度 = P.速度 - self:取效果(P)
end

function 法术:取效果(P)
    local 亲密 = P.亲密 or 0
    return math.floor(150 + (亲密 ^ 0.271))
end

function 法术:法术取描述(P)
    return string.format("步履蹒跚，灵敏度下降。#r#W【技能介绍】#r#G减少召唤兽SP%s", self:取效果(P))
end

return 法术
