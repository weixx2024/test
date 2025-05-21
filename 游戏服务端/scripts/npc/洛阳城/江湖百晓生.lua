local NPC = {}
local 对话 = [[
我行走江湖，有奇闻异事的见闻录，也收集指南录，不知道你有没有？当然，我也不会白拿，我这里有许多宝图。
menu
1|兑换高级藏宝图（需要3本见闻录）
2|兑换超级藏宝图（需要5本指南录）
99|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家:取包裹空位() then
            玩家:提示窗口('#Y 你的包裹已经满了！')
            return
        end
        local r = 玩家:取物品是否存在("见闻录")
        if r then
            if r.数量 < 3 then
                return "你身上没有足够多的见闻录"
            end
            local wp = 生成物品 { 名称 = "高级藏宝图", 数量 = 1 }
            if 玩家:添加物品({ wp }) then
                r:减少(3)
            end
        else
            return "你身上没有足够多的见闻录"
        end
    elseif i == '2' then
        if not 玩家:取包裹空位() then
            玩家:提示窗口('#Y 你的包裹已经满了！')
            return
        end
        local r = 玩家:取物品是否存在("指南录")
        if r then
            if r.数量 < 5 then
                return "你身上没有足够多的指南录"
            end
            local wp = 生成物品 { 名称 = "超级藏宝图", 数量 = 1 }
            if 玩家:添加物品({ wp }) then
                r:减少(5)
            end
        else
            return "你身上没有足够多的指南录"
        end

    end
end

return NPC
