local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '暗骨',
    是否被动 = true,
}

function 法术:计算_后特技(P,dj)
    local 根骨 = P.装备属性.根骨 + P.根骨 + P.其它.四维加成 * 10
    P.抗性.忽视抗睡 = (P.抗性.忽视抗睡 or 0) + math.floor(根骨/20/10)
end

return 法术
