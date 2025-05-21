local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '金钟罩',
    是否被动 = true,
    战斗可用 = true,
}

function 法术:物理免疫(攻击方,挨打方,数据)
    if math.random(100) < 10 then
        数据:目标添加特效(1501,挨打方.位置)
        return true
    end
end



return 法术
