local NPC = {}
local 对话 = [[
最近都没有什么大事发生，看来今天的早朝可以很快就结束了。
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
