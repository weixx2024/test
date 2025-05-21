local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '信手拈来',
    是否被动 = true,
    战斗可用 = true,
}

function 法术:增加法术目标(n)
    return n+1
end

return 法术
