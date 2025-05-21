local NPC = {}
local 对话 = [[最近这儿特别热闹，我觉得那都是我的功劳，请问要去哪呢?
menu
1|长安桥 5|江洲
2|长安武馆 6|洪洲
3|大雁塔 7|丰都
4|皇宫门口 99|我什么都不想做
]]


--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1001, 251, 91)
    elseif i == '2' then
        玩家:切换地图(1001, 315, 33)
    elseif i == '3' then
        玩家:切换地图(1001, 85, 228)
    elseif i == '4' then
        玩家:切换地图(1001, 301, 251)
    elseif i == '5' then
        玩家:切换地图(1110, 470, 80)
    elseif i == '6' then
        玩家:切换地图(1110, 85, 88)
    elseif i == '7' then
        玩家:切换地图(1110, 20, 12)
    end
end

return NPC
