local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '顾影自怜',
}

function 法术:回合开始(攻击方, 挨打方)
    if 攻击方:随机我方未封印目标() <= 攻击方:我方总目标数()*0.4 then
        local BUFF类型 = {"封印","混乱"}
        for i,v in ipairs(BUFF类型) do
            攻击方:删除BUFF(v)
        end
    end
end

function 法术:法术取描述(P)
    return string.format("回合开始时，若己方活着且未被控制的单位数≤参战人数的40%%时，自身摆脱一切被控制的状态。")
end

return 法术
