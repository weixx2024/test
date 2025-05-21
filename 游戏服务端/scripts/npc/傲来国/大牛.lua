local NPC = {}
local 对话 = [[
傲来北边是女儿村，南边通海底迷宫，可别走错方向咯。
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
