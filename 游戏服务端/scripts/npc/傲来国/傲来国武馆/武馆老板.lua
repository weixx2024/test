local NPC = {}
local 对话 = [[
说起傲来国，没人会不知道女儿村的，那里妹妹可多了。
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
