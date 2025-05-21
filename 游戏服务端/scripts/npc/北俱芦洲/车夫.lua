

local NPC = {}
local 对话 = [[冷，好冷啊，赚点钱真不容易，你要去哪里?
menu
洛阳
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='洛阳' then
        玩家:切换地图(1236, 114, 94)
    end
    
end



return NPC