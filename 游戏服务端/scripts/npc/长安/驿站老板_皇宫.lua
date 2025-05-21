local NPC = {}
local 对话 = [[这里是皇宫门口，皇宫大臣们都从我这里坐车，平民也一律享受皇家级的待遇，你要去哪里?
menu
1|长安桥 5|洛阳集市
2|长安武馆 6|万寿山
3|长安留香阁 7|白骨洞
4|大雁塔 99|我什么都不想做
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
        玩家:切换地图(1001, 69, 17)
    elseif i == '4' then
        玩家:切换地图(1001, 85, 228)
    elseif i == '5' then
        玩家:切换地图(1236, 358, 70)
    elseif i == '6' then
        玩家:切换地图(1299, 35, 98)
    elseif i == '7' then
        玩家:切换地图(101301, 15, 9)
    end
end

return NPC
