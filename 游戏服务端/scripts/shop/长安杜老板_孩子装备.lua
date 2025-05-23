﻿local 商店 = {}

local list = {
    -- { 类别 = "孩子装备", 名称 = '粗布衣', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '麻衣', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '丝绸外衣', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '书生服', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '八卦道袍', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '粗布裙', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '麻裙', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '轻纱小裙', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '丝绸长裙', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '织女彩裙', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '布帽', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '方巾', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '纶巾', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '书生巾', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '天师法冠', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '银簪', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '玉钗', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '珍珠头钗', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '凤钗', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '织女花环', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '草鞋', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '布鞋', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '马靴', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '书生履', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '天师履', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '绣花鞋', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '云靴', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '织女彩鞋', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '木筝', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '宝螺筝', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '楠木花卉筝', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '红木山水画筝', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '骨雕飞天筝', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '木剑', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '竹剑', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '青铜剑', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '越女剑', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '龙泉剑', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '庄子', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '孟子', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '论语', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '道德经', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '周易', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '翎毛扇', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '白羽扇', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '鹅毛扇', 价格 = 5000000 },
    -- { 类别 = "孩子装备", 名称 = '鹤羽扇', 价格 = 5000000 },
    { 类别 = "孩子装备", 名称 = '麈尾扇', 价格 = 5000000 },
}

function 商店:取商品()
    return list
end

function 商店:购买(玩家, i, n)
    if not 验证数字(n) then
        return
    end
    local 总价 = n * list[i].价格
    if 玩家.银子 >= 总价 then
        local t = 复制表(list[i])
        t.类别 = nil
        t.价格 = nil
        local 物品表 = {}
        local 第一 = 生成装备_孩子(t)
        if 第一.是否叠加 then
            第一.数量 = n
            table.insert(物品表, 第一)
        else
            for _ = 1, n do
                table.insert(物品表, 生成装备_孩子(t))
            end
        end
        if 玩家:添加物品_无提示(物品表) then
            玩家:扣除银子(总价)
            玩家:提示窗口('#Y你购买了%s个#G%s#Y,共花费%s银两。',  n,t.名称, 总价)
            return true
        else
            return '#Y空间不足'
        end

    else
        return '#Y你的银两不足，不能购买！'
    end
end

return 商店
