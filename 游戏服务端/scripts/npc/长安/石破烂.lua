local NPC = {}
local 对话 = [[
我平时就是走街串巷的收点破烂。你有什么不需要的废品吗?卖不？照顾下生意啊#14
menu
1|我要卖点东西
2|怎么个卖法？
3|离开
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

local _回收表 = {
    九彩云龙珠=3000,
    血玲珑=9000,
    内丹精华=18000,
    乌金=300,
    金刚石=3000,
    寒铁=10000,
    百炼精铁=20000,
    龙之鳞=40000,
    千年寒铁=80000,
    天外飞石=160000,
    盘古精铁=320000,
    补天神石=800000,

}











function NPC:NPC给予(玩家, cash, items)
    if items and items[1] then
        local jg = items[1]:取回收价格(玩家)
        if jg then
            local zj = items[1].数量 * jg
            玩家:添加师贡(zj)
            -- 玩家:添加银子(zj)
            items[1]:接受(items[1].数量)
            return
        end
    end
    return "我可不是什么东西都要的#24"
end

return NPC
