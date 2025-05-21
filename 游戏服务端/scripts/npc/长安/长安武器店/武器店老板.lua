local NPC = {}
local 对话 = [[
行家一出手，就知有没有，你想买什么？
menu
1|我想用银子买点东西

9|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安兵器.lua')
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
