local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '定海神针',
    是否被动 = true,
}

function 法术:计算_后特技(P, dj)
    -- if not P:取特技是否存在('皮糙肉厚') then
        P.最大气血 = math.floor(P.最大气血 * 1.4)
    -- end
end

return 法术
