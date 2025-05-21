local NPC = {}
local 对话 = [[
恭喜发财！！好运常来！！
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
end

function NPC:NPC给予(玩家, cash, items)
end

return NPC