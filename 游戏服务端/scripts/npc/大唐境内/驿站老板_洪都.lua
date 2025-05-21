local NPC = {}
local 对话 = [[这里是洪洲驿站，最近猪肉涨价，车费自然也要跟着提啦，想要去哪呢?
menu
1|长安桥
2|长安留香阁
3|长安东
99|我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1001, 251, 91)
    elseif i == '2' then
        玩家:切换地图(1001, 69, 17)
    elseif i == '3' then
        玩家:切换地图(1193, 304, 186)
    end
end

return NPC
