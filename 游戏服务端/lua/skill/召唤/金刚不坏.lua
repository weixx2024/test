local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '金刚不坏',
    id = 304,

}

function 法术:计算_召唤(P)
    P.抗性.抗致命几率 = math.floor(P.抗性.抗致命几率 +self:取效果(P))
end

function 法术:取效果(P)
    local 亲密 = P.亲密 or 0
    return math.floor( 20 + (亲密 ^ 0.215))
end

function 法术:法术取描述(P)
    return string.format("被物理攻击时，有%s%%几率免疫致命伤害（被动）。",self:取效果(P))
end

return 法术
