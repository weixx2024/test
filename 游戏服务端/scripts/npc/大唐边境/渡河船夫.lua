local NPC = {}
local 对话 = [[这河对岸就是四圣庄，不过流沙河水势凶险，又被卷帘大将占据，常人根本无法通过，只有我的船可以，哈哈。
menu
四圣庄
我什么都不想做
]]


--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='四圣庄' then
        玩家:切换地图(101295, 206, 35)
    end
    
end



return NPC