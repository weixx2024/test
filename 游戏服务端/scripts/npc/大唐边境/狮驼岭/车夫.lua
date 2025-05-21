local NPC = {}
local 对话 = [[妖怪也有灵性，只要多买点肉给它们吃，就能跟它们搞好关系。
menu
洛阳
火云洞
我什么都不想做 
]]
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='洛阳' then
        玩家:切换地图(1236, 114, 94)  
    elseif i=='火云洞' then
        玩家:切换地图(101541, 16, 8)
    end
end



return NPC