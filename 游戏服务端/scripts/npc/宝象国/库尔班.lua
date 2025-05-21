local NPC = {}
local 对话 = [[远方的客人，你要去何处?
menu
宝象国商会 
宝象国光禄寺
陈家村
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='宝象国商会' then
        玩家:切换地图(101529, 251, 145)
    elseif i=='宝象国光禄寺' then  
        玩家:切换地图(101529, 209, 16) 
    elseif i=='陈家村' then  
        玩家:切换地图(101538, 179, 74)      
        

    end
end



return NPC