local NPC = {}

local 对话 = [[
寄语婵娟，愿逐月华，流照远人。
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
