local NPC = {}
local 对话 = [[
我这里出售各种宝宝养育物品，您要点什么？
menu
1|我就是来买得
2|孩子装备
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安杜老板.lua')
    elseif i == '2' then
        玩家:购买窗口('scripts/shop/长安杜老板_孩子装备.lua')
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
