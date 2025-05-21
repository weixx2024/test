local NPC = {}
local 对话 = [[这里就是长安最繁华的地方，长安清风桥，哈哈，你要去哪里呢?
menu
1|江洲 5|洛阳集市
2|丰都 6|东海渔村
3|洪洲 7|大雁塔
4|洛阳 99|我什么都不想做
]]
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1110, 470, 80)
    elseif i == '2' then
        玩家:切换地图(1110, 20, 12)
    elseif i == '3' then
        玩家:切换地图(1110, 85, 88)
    elseif i == '4' then
        玩家:切换地图(1236, 114, 94)
    elseif i == '5' then
        玩家:切换地图(1236, 358, 70)
    elseif i == '6' then
        玩家:切换地图(1208, 24, 52)
    elseif i == '7' then
        玩家:切换地图(1001, 85, 228)
    end
end

return NPC
