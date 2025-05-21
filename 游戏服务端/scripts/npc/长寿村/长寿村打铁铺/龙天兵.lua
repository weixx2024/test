local NPC = {}
local 对话 = [[
三界灵石为万灵之根，有了他什么样的神兵都能打造出来！你想不想知道详细点？
menu
1|想
2|离开
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
