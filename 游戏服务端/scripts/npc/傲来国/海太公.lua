

local NPC = {}
local 对话 = [[我可以送你去大船，只需会儿便可到蓬 莱仙岛了
menu
大船甲板 
长安东 
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='长安东' then
        玩家:切换地图(1193, 304, 186)
    elseif i=='大船甲板' then
        --玩家:切换地图(1193, 251, 145)      
    end
end



return NPC