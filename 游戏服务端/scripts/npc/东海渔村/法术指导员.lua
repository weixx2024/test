local NPC = {}
local 对话 = [[相见即为有缘，我稍微懂点微末之技，你想学习什么呢？
menu
]]





function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)

end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end
return NPC
