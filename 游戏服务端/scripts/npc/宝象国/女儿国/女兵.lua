local NPC = {}
local 对话 = [[我负责女儿国境内的传送，你想去哪里呢？
menu
洛阳镖局 
女儿国郊外 
我什么都不想做 
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='洛阳镖局' then
        玩家:切换地图(1236, 331, 165)
    elseif i=='女儿国郊外' then
        玩家:切换地图(101550, 108, 101)
    end
end

return NPC