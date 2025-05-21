local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '万古同悲',
    种族 = 2 --天界
}

function 法术:取仙法增加(攻击方,挨打方,伤害)
    local 灵性 = 攻击方.灵性
    return 伤害 + math.floor(伤害*灵性/1000)
end


return 法术
