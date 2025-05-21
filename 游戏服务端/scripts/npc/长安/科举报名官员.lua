local NPC = {}
local 对话 = [[
奉唐王之命，举办御前科举招才纳贤。天下所有有志之士都可以来我这报名。名列前茅者唐王重重有赏。
menu
1|我想报名文科比试
2|我只是路过看看
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
