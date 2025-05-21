

local NPC = {}
local 对话 = [[我是在这里负责送人回洛阳城的，如果你想回洛阳城的话我可以帮帮你。
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