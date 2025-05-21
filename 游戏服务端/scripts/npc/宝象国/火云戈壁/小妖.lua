local NPC = {}
local 对话 = [[我们火云洞是妖界新星，因为圣婴大王又有实力又有背景。
menu
陈家村
狮驼岭
魔王寨
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='陈家村' then
        玩家:切换地图(101538, 179, 74)    
    elseif i=='狮驼岭' then 
        玩家:切换地图(1131, 34, 14)   
    elseif i=='魔王寨' then 
        玩家:切换地图(1145, 16, 9)         

    end
    
end



return NPC