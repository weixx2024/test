-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-07-19 06:33:17

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
