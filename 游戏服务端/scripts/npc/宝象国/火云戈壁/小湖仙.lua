local NPC = {}
local 对话 = [[相传情人湖是嫦娥奔月的时候落下的一滴眼泪哦!
menu
平顶山胡杨林
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='平顶山胡杨林' then
        玩家:切换地图(101537, 20, 99)
    end
    
end



return NPC