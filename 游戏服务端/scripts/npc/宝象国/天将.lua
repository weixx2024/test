local NPC = {}

local 对话 = [[每周一19:40-20:20可以找我传送至种族比武场!
menu
1|我要进入比武场
2|我就看看

]]




function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local id = (玩家.种族 + 2) * 10000 + 1197
        玩家:切换地图(id, 75, 53)
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
