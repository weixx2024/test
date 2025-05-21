local NPC = {}
local 对话 = [[
步长，一步之长，其实每一米走多远不重要，重要的是你能不能一直走下去
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
