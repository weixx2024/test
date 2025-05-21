local NPC = {}
local 对话 = [[这里是大唐边境，它除了是美丽的天然公园之外，其实还是个练习法术的好去处，不信你看我，几个法全都满了....我可以送你回洛阳。
menu
洛阳
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='洛阳' then
        玩家:切换地图(1236, 114, 94)
    end
    
end



return NPC