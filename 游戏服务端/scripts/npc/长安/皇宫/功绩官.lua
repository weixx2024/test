local NPC = {}
local 对话 = [[
我大唐英雄，入凌烟阁地宫降妖除魔，胜者，唐王以功绩论赏！
menu
1|我要兑换物品
2|了解功绩兑换规则
4|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/积分_地宫.lua', '地宫积分')
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
