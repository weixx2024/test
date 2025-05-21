local NPC = {}
local 对话 = [[
最近有消息说不少旅行商人在旅途中迷了路，不知道大侠你行走江湖的时候有没有看到这些商人？
menu
1|我正是带他们回来的
2|他们可能会在那些地方迷路
3|我只是路过看看
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
