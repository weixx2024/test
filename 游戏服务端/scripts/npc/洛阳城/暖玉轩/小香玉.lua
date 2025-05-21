local NPC = {}
local 对话 = [[
我轻轻的来，不带走一片云彩，但一定要带走你的钞票。
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
