local NPC = {}
local 对话 = [[
我叫魏大宝，魏大宝的魏，魏大宝的大，魏大宝的宝#89
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
