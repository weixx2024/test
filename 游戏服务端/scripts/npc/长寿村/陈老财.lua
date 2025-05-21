local NPC = {}
local 对话 = [[
长寿村外的空地经常有妖怪骚扰，要是出去可要小心点。
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
