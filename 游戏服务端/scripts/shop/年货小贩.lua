local 商店 = {}

local list = {
    { 类别 = "道具", 名称 = "飞行旗", 价格 = 650 },
    { 类别 = "道具", 名称 = "高级飞行旗", 价格 = 24000 },
    { 类别 = "道具", 名称 = "孔明灯", 价格 = 650000 },
    { 类别 = "道具", 名称 = "宠物口粮", 价格 = 50 },
 
}

function 商店:取商品(玩家)
    local r = {}
    local rw = 玩家:取任务("元宵_团员年饭")
    if rw then
        return rw:取商品(玩家)
    end
    return r
end

function 商店:购买(玩家, i, n)
    if not 验证数字(n) then
        return
    end
    local sp = self:取商品(玩家)
    if sp and sp[i] then
        local 总价 = n * sp[i].价格
        if 玩家.银子 >= 总价 then
            local t = 复制表(sp[i])
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
                玩家:提示窗口('#Y你购买了%s个#G%s#Y,共花费%s银两。',  n,t.名称, 总价)
                return true
            else
                return '#Y空间不足'
            end
    
        else
            return '#Y你的银两不足，不能购买！'
        end
    end
end

return 商店
