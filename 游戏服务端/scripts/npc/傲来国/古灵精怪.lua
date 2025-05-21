local NPC = {}
local 对话 = [[此树是我栽，此船是我开，要从我这过，留下买路财。
menu
大唐边境东
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '大唐边境东' then
        玩家:切换地图(1173, 603, 42)
    end
end

return NPC
