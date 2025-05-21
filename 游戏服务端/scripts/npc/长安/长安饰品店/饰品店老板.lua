local NPC = {}
local 对话 = [[
饰品不仅可以使你看起来更漂亮，而且也有特别的功效哦！
menu
1|我想买点东西
2|我想购买内丹
3|我想购买宝石
99|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安饰品店.lua')
    elseif i == '2' then
        玩家:购买窗口('scripts/shop/长安饰品店_内丹.lua')
    elseif i == '3' then
        玩家:购买窗口('scripts/shop/长安饰品店_宝石.lua')
    end
end

return NPC
