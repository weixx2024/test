local NPC = {}
local 对话 = [[你要去西牛贺洲啊，我送你一程吧，收取20两银子作为报酬。
menu
好的，快送我去西牛贺洲
我什么都不想做 
]]
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='好的，快送我去西牛贺洲' then
        玩家:切换地图(1091, 84, 12)  
    end
end



return NPC