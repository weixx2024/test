local NPC = {}
local 对话 = [[
方丈特派我在此准备了些小东西，侠士们可以在这里用除妖过程中给的积分来换取。
menu
1|我要换奖励
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/积分_大雁塔.lua', '大雁塔积分')
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
