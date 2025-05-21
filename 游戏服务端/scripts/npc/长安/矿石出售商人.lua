local NPC = {}
local 对话 = [[
我是天下闻名的铸造师，为了铸造出最好的兵器，需要无数矿石冶炼，但是我很难找到需要的矿石，你可以给我需要的东西吗？我会付给你金钱酬劳，如果你有，直接给我，见货付款。
menu
1|我想用银子买点东西
5|我什么都不想做
]]
--3|我要卖点东西
function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安矿石收购商.lua')
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
