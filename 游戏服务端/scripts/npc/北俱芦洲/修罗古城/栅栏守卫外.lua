local NPC = {}
local 对话 = [[
menu
我要去修罗古城看看
没事，看你挺无聊的想和你聊聊天而已
]]
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='我要去修罗古城看看' then
        玩家:切换地图(101381, 107, 83)
    end
end


return NPC