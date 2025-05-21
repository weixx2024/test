local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '疾如雷电.lua',
    是否被动 = true,
}

function 法术:计算_前特技(P,dj)
    P.装备属性.敏捷 = P.装备属性.敏捷 + dj*50
end

return 法术
