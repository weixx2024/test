local NPC = {}
local 对话 = [[
至富可敌贵，天子天下之贵，元宝天下之富！阁下此来有何贵干？
menu
1|让我看看你有啥东西！
2|购买符文
99|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
        玩家:购买窗口('scripts/shop/符文商店.lua')
    end
end

return NPC
