local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '龙象般若',
    是否被动 = true,
}

function 法术:法术取描述(攻击方, 挨打方)
    return "真如白象 空若云龙 无上智慧 洞悉诸法。可增加召唤兽物理攻击时的狂暴几率与致命几率。"
end

function 法术:取效果(P)
    local qm = P.亲密 or 0
    return 15+math.floor(qm^0.195)
end

function 法术:计算_召唤(P)
    P.抗性.狂暴几率 = P.抗性.狂暴几率 + self:取效果(P)
    P.抗性.致命几率 = P.抗性.致命几率 + self:取效果(P)
end


return 法术
