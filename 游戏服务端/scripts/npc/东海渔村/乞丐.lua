local NPC = {}
local 对话 = [[
谢谢你给我钱啦，这个渔村里，也只有你一个好心人了。
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
