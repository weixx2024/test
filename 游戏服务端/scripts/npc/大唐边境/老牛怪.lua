local NPC = {}
local 对话 = [[欢迎乘坐大唐边境傲来国专线航班，这船除了傲来国哪都不去。
menu
1|傲来国
99|我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(1092, 220, 213)
    end
    
end



return NPC