local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '刀枪不入',
    是否被动 = true,
}

function 法术:计算_召唤(P)
    P.抗性.防御值 = P.抗性.防御值 + self:取效果(P)
end

function 法术:取效果(P)
    local 亲密 = P.亲密 or 0
    return math.floor( 6000 + (亲密 * 1 /10000))
end

function 法术:法术取描述(攻击方, 挨打方)
    local str = self:取效果(攻击方) .. "%"
    return string.format("增加召唤兽%s防御值。",str)
end

return 法术
