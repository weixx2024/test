local NPC = {}
local 对话 = [[“飞机”是什么?不要跟我说这么深奥的词汇，直接说去哪里吧?
menu
1|狮驼岭
2|我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(1131, 34, 14)
    end
end



return NPC