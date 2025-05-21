local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '???',
}

function 法术:法术取描述(P)
    return string.format("使用“终极技能修炼丹”有概率开启终极技能！")
end

return 法术
