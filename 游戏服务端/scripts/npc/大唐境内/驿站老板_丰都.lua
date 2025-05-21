local NPC = {}
local 对话 = [[这里是著名的鬼城丰都，为什么叫鬼城?因为这里经常闹鬼，害怕了吗?还是让我送你回长安吧。
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
