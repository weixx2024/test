local NPC = {}
local 对话 = [[
长安北边就是皇宫了，当今皇上和文武百官都在那里处理国家大事。
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
