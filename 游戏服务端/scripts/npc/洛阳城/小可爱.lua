local NPC = {}
local 对话 = [[
我妈妈好久没来看望我了，听说是有人把她号盗走了，我想找回我妈妈#52
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
