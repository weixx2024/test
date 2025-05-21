local NPC = {}
local 对话 = [[
行家一出手，就知有没有，你想买什么？
menu
1|我想买点东西
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/傲来武器店.lua')
    end
end

return NPC
