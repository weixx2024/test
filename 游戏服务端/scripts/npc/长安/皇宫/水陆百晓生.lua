local NPC = {}
local 对话 = [[
足不出户，便晓天下大事，轻轻一按，信息信手拈来。你好！我是水陆大会百晓生，有什么我能帮助你的吗#55
menu
1|查询风云积分榜
2|查询积分情况
3|玲珑积分兑换
4|战神积分兑换
5|王者积分兑换
6|离开
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
