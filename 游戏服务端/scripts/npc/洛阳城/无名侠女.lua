local NPC = {}
local 对话 = [[
都五百年了，他还没有出现，也不知道他会不会长的像对面那个傻搓搓...
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
