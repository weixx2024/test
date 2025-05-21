local NPC = {}
local 对话 = [[
我是专门收取厌倦尘世玩家性命的，如果你不再留恋这里的一切，那么我帮助你完成心愿。你真的要这样做吗？
menu
1|生亦何哀，死亦何苦？你就让我死了算了
2|我什么都不想做
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
