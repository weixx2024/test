local NPC = {}
local 对话 = [[
南瞻部洲的妖怪可多了，可别被抓去下酒啊。
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
