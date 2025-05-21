local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '伤筋动骨',
    是否被动 = true,
    战斗可用 = true,
}

function 法术:取毒法增加(攻击方,挨打方,伤害)
    return 伤害 + math.floor(伤害*0.1)
end


return 法术
