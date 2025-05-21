local NPC = {}
local 对话 = [[
你找我有什么事。
menu
1|兑换奖励
4|我只是路过看看
]]
function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        玩家:购买窗口('scripts/shop/积分_木魅.lua', '木魅积分')
    elseif i == "2" then
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
