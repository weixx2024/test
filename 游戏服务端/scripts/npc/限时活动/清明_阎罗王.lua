local NPC = {}
local 对话 = [[
何方人物，竟敢挑战地府的威严#4
menu
1|挑战
99|放弃挑战
]]




function NPC:NPC对话(玩家)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if os.date('%w', os.time()) ~= '6' then
            return "非活动开启时间"
        end
        玩家:进入战斗('scripts/war/清明_boss.lua')
    end
end

return NPC
