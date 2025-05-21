local 商店 = {}

local list = {
    { 类别 = "普通装备", 名称 = "鹅毛帽", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "凤头钗", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "妖气斗篷", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "五彩裙", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "舍利珠", 价格 = 40000 },
    { 类别 = "普通装备", 名称 = "追星踏月", 价格 = 40000 },
}

function 商店:取商品()
    return list
end

function 商店:购买(玩家, i, n)
    local 总价 = n * list[i].价格
    local r = 玩家:选择窗口('请选择扣除货币#Y注:师贡购买道具无法交易！\nmenu\n1|师贡\n\n2|银子')
    if not r then
        return
    end
    if r == "1" then
        return self:师贡购买(玩家, i, n)
    elseif r == "2" then
        return self:银子购买(玩家, i, n)
    end
end

function 商店:师贡购买(玩家, i, n)
    local 总价 = n * list[i].价格

    local t = 复制表(list[i])
    t.类别 = nil
    t.价格 = nil
    t.禁止交易 = true
    local 物品表 = {}
    for _ = 1, n do
        table.insert(物品表, 生成装备(t))
    end
    if not 玩家:物品检查添加(物品表) then
        return '#Y空间不足'
    end
    if 玩家:扣除师贡(总价) then
        玩家:添加物品_无提示(物品表)
        玩家:提示窗口('#Y你购买了%s个#G%s', n, t.名称)
    end
end

function 商店:银子购买(玩家, i, n)
    local 总价 = n * list[i].价格
    if 玩家.银子 >= 总价 then
        local t = 复制表(list[i])
        t.类别 = nil
        t.价格 = nil
        local 物品表 = {}
        for _ = 1, n do
            table.insert(物品表, 生成装备(t))
        end
        if 玩家:添加物品_无提示(物品表) then
            玩家:扣除银子(总价)
            玩家:提示窗口('#Y你购买了%s个#G%s#Y,共花费%s银两。', n, t.名称, 总价)
            return true
        else
            return '#Y空间不足'
        end

    else
        return '#Y你的银两不足，不能购买！'
    end
end

return 商店
