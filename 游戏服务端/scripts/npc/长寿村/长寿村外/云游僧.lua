local NPC = {}
local 对话 = [[
五指山?听说是如来佛祖的手变的哦。。
menu
1|大唐边境
2|我什么都不想做
]]
function NPC:NPC对话(玩家, i)
    return 对话
end
function NPC:NPC菜单(玩家, i)
    if i == "1" then
        玩家:切换地图(1173, 62, 21)
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
