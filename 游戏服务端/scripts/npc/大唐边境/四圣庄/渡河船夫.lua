local NPC = {}
local 对话 = [[这河对岸就是大唐边境，不过流沙河水势凶险，又被卷帘大将占据，常人根本无法通过，只有我的船可以，哈哈。
menu
1|大唐边境
99|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        玩家:切换地图(1173, 145, 111)
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
