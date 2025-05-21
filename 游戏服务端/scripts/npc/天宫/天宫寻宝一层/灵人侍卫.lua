local NPC = {}
local 对话 = [[
本尊目前体力为#Y%s#W点，当我们体力降至0时，本层宝物必将浮现于世。
menu
1|挑战
2|放弃
]]

function NPC:NPC对话(玩家, i)
    return string.format(对话, 天宫寻宝_取守卫体力(1))
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        if 天宫寻宝_取守卫体力(1) > 0 then
            玩家:进入战斗('scripts/war/宝库_守卫1.lua')
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
