local NPC = {}
local 对话 = [[这里是洛阳镖局驿站，最近人好少啊，不过生意还是要做的，你要去哪里呢?
menu
皇宫门口 女儿国王宫
洛阳 我什么都不想做
洛阳集市
宝象国商会
]]

--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '皇宫门口' then
        玩家:切换地图(1001, 301, 251)
    elseif i == '洛阳' then
        玩家:切换地图(1236, 114, 94)
    elseif i == '洛阳集市' then
        玩家:切换地图(1236, 355, 66)
    elseif i == '宝象国商会' then
        玩家:切换地图(101529, 251, 145)
    elseif i == '女儿国王宫' then
        玩家:切换地图(101550, 285, 131)
    end
end

return NPC
