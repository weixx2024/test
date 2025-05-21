local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '忠肝义胆',
    id = 304,

}





function 法术:计算_召唤(P)
    --  local 亲密 = P.亲密 or 0
    P.抗性.忠肝义胆 = math.floor(P.抗性.忠肝义胆 + 50)
end

function 法术:法术取描述(P)
    -- local 亲密 = P.亲密 or 0
    -- local sp = math.floor(150 + (亲密 ^ 0.271))
    return "死亡后有几率不掉忠诚度。"
end

return 法术
