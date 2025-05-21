local 商店 = {}

local list = {
    { 类别 = "道具", 名称 = "无常丹", 价格 = 5600 },
    { 类别 = "道具", 名称 = "九花玉露丸", 价格 = 6200 },
    { 类别 = "道具", 名称 = "千年血参", 价格 = 6400 },
    { 类别 = "道具", 名称 = "二十一味清目丸", 价格 = 7100 },
    { 类别 = "道具", 名称 = "千年灵花", 价格 = 3200 },
    { 类别 = "道具", 名称 = "千年沉香", 价格 = 4000 },
    { 类别 = "道具", 名称 = "青月灵草", 价格 = 4800 },
    { 类别 = "道具", 名称 = "血烟石", 价格 = 3600 },
    { 类别 = "道具", 名称 = "火凤之睛", 价格 = 4500 },
    { 类别 = "道具", 名称 = "龙之心屑", 价格 = 5400 },
    { 类别 = "道具", 名称 = "夜叉石", 价格 = 15400 },
    { 类别 = "道具", 名称 = "海蓝石", 价格 = 15400 },

}

function 商店:取商品()
    return list
end

function 商店:购买(玩家, i, n)
    if not 验证数字(n) then
        return
    end
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
    local 第一 = 生成物品(t)
    if 第一.是否叠加 then
        第一.数量 = n
        table.insert(物品表, 第一)
    else
        for _ = 1, n do
            table.insert(物品表, 生成物品(t))
        end
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
        local 第一 = 生成物品(t)
        if 第一.是否叠加 then
            第一.数量 = n
            table.insert(物品表, 第一)
        else
            for _ = 1, n do
                table.insert(物品表, 生成物品(t))
            end
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
