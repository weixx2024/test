local NPC = {}
local 对话 = [[想下山吗？我送你一程吧。
menu
大唐边境南
我什么都不想做
]]
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '大唐边境南' then
        玩家:切换地图(1173, 43, 22)
    end
end

return NPC
