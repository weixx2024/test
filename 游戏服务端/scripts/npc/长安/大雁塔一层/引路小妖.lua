local NPC = {}
local 对话 = [[这里是大雁塔驿站，大雁塔最近重新修缮了一番，比以前更漂亮了#89，请问要去哪呢?
menu
1|大雁塔六层
99|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i=="1" then
        玩家:切换地图(1090, 129, 51)
    end


end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
