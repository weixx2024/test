local NPC = {}
local 对话 = [[我们一家四兄弟可都是这附近名声在外的车夫，赶车又快又稳!这位爷，出去玩么?
menu
宝象国皇宫
火云洞
长寿村
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='长寿村' then
        玩家:切换地图(1070, 51, 19)
    elseif i=='宝象国皇宫' then
        玩家:切换地图(101529, 73, 135)
    elseif i=='火云洞' then
        玩家:切换地图(101541, 16, 8)

    end
    
end



return NPC