local NPC = {}
local 对话 = [[
我是一个小小草，长呀长高高！
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
end

function NPC:NPC给予(玩家, cash, items)
end

return NPC