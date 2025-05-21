local NPC = {}
local 对话 = [[这里是洛阳的驿站，为什么会开在青楼旁边呢?这是个复杂的问题#3想要去哪呢?
menu
狮驼岭 长安桥
蟠桃园 洛阳集市
大唐边境 洛阳镖局
北俱芦洲 我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '长安桥' then
        玩家:切换地图(1001, 251, 91)
    elseif i == '狮驼岭' then
        玩家:切换地图(1131, 34, 14)
    elseif i == '蟠桃园' then
        玩家:切换地图(1198, 46, 43)
    elseif i == '大唐边境' then
        玩家:切换地图(1173, 176, 149)
    elseif i == '北俱芦洲' then
        玩家:切换地图(1174, 49, 47)
    elseif i == '洛阳集市' then
        玩家:切换地图(1236, 355, 66)
    elseif i == '洛阳镖局' then
        玩家:切换地图(1236, 331, 165)
    end
end

return NPC
