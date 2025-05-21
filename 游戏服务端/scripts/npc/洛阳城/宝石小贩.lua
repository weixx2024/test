local NPC = {}
local 对话 = [[
收宝石喽，收宝石喽，童叟无欺，洛阳城外仅此一家。走过路过不要错过。
menu
1|我想买点东西
9|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/宝石小贩.lua')
    elseif i == '2' then
    end
end

return NPC



-- function NPC:NPC对话(玩家, i)
--     return 对话
-- end

-- function NPC:NPC菜单(玩家, i)
--     if i == '1' then
--         玩家:购买窗口('scripts/shop/宝石小贩.lua')
--     elseif i == '2' then
--     elseif i == '3' then
--     elseif i == '4' then
--     end
-- end

-- return NPC