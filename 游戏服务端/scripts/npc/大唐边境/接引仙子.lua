local NPC = {}
local 对话 = [[当神仙也累啊，还得整天干苦力..又来一个，你要去普陀山?
menu
普陀山
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='普陀山' then
        玩家:切换地图(1140, 24, 11)
    end
    
end



return NPC