local NPC = {}
local 对话 = [[
吾奉天庭之命前来镇压地煞之星，尔等打败收服了那些地煞星，就可来此兑换赏赐。不过那些地煞星本领甚是不凡，不是寻常人等能对付得了的。
menu
1|兑换奖励
2|查询积分
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
