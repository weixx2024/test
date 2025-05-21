
local NPC = {}
local 对话 = [[屋檐如悬崖风铃如沧海我等雁归来~~~我可以送你去美丽的情人岛。
menu
情人岛 
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='情人岛' then
        玩家:切换地图(1193, 50, 109)
    end
end



return NPC