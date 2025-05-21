local NPC = {}
local 对话 = [[
我就是所有帮派的总管，你找我有什么事吗?
menu
1|我要建立帮派
2|我来响应帮派
3|我要加入帮派
4|我们要合并帮派
5|我什么都不想做
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
