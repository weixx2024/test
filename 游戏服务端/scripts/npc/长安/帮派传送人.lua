local NPC = {}
local 对话 = [[
你还没有帮派呢，不能传送。
menu
1|送我回帮派
2|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家.帮派 or 玩家.帮派 == "" then
            return "你还没有帮派呢！"
        end
        玩家:进入帮派(玩家.帮派)

    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
