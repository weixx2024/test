local NPC = {}
local 对话 = [[赚点钱不容易，别看我是“老板”，其实赚的都是辛苦钱啊， 请问想要去哪呢?
menu
1|长安桥
2|长安留香阁
00|我什么都不想做
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
    end
end

return NPC
