local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '积水为海',
    是否被动 = true,
}

function 法术:计算_召唤(P)
    if P.接口 and P.接口.取内丹是否存在 and P.接口:取内丹是否存在("大海无量") then
        P.抗性.大海无量 = P.抗性.大海无量 + 10
    end
end

function 法术:进入战斗(P)
    P.命中率 = P.命中率 * 1.3
end

function 法术:法术取描述(攻击方, 挨打方)
    return "命中提高33%，修罗内丹大海无量几率提高10%。"
end


return 法术

