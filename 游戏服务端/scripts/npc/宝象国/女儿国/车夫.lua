local NPC = {}
local 对话 = [[咱们女儿国的女子，个个都是上得厅堂下得厨房，能进战场能打流氓
menu
洛阳镖局
女儿国王宫
我什么都不想做]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='洛阳镖局' then
        玩家:切换地图(1236, 331, 165)
    elseif i=='女儿国王宫' then
        玩家:切换地图(101550, 285, 131)
    end
end

return NPC