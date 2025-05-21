local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '禅定',
    种族 = 2 --天界
}

function 法术:取鬼法减少(挨打方,攻击方,伤害)
    local 根骨 = 挨打方.根骨
    local xs = 根骨/1000
    if xs > 0.8 then  xs = 0.8 end
    return 伤害 - math.floor(伤害*xs)
end

function 法术:取仙法减少(挨打方,攻击方,伤害)
    local 根骨 = 挨打方.根骨
    local xs = 根骨/1000
    if xs > 0.8 then  xs = 0.8 end
    return 伤害 - math.floor(伤害*xs)
end

return 法术
