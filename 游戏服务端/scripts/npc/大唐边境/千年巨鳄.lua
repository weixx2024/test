local NPC = {}
local 对话 = [[
哈哈，好嫩的小娃娃，正好给爷爷我做下酒菜！！
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
end

function NPC:NPC给予(玩家, cash, items)
end

return NPC
