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
        玩家:切换地图(1001, 301, 251)
    elseif i == '5' then
        玩家:切换地图(101529, 209, 16)
    elseif i == '6' then
        玩家:切换地图(1173, 41, 23)
    end
end

return NPC
