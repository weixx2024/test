local NPC = {}
local 对话 = [[这里是傲来国驿站，想要去哪呢?
menu
长安桥
洛阳
宝象国商会
我什么都不想做
]]
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '长安桥' then
        玩家:切换地图(1001, 251, 91)
    elseif i == '洛阳' then
        玩家:切换地图(1236, 114, 94)
    elseif i == '宝象国商会' then
        玩家:切换地图(101529, 251, 145)
    end
end

return NPC
