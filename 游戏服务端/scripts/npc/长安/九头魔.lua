local NPC = {}
local 对话 = [[这里是大雁塔驿站，大雁塔最近重新修缮了一番，比以前更漂亮了#89，请问要去哪呢?
menu
1|长安桥
2|长安武馆
3|长安留香阁 
4|皇宫门口
5|宝象国光禄寺
6|大唐边境南
99|我什么都不想做
]]
function NPC:NPC对话(玩家, i)
    return '你找我有什少时诵诗书么事？'
end

function NPC:NPC菜单(玩家, i)

end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
