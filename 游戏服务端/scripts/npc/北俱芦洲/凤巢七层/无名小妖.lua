local NPC = {}
local 对话 = [[
看什么看，再看把你吃掉！
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
end

function NPC:NPC给予(玩家, cash, items)
end

return NPC
