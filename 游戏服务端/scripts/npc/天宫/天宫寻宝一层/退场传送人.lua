local NPC = {}
local 对话 = [[
吾乃是守护天帝宝库大将。
menu
1|我要出去
2|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1208, 58, 110)
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
