local NPC = {}

function NPC:NPC对话(玩家, i)
    return '你找我有什么事？'
end

function NPC:NPC菜单(玩家, i)
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end
return NPC
