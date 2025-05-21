

local NPC = {}
local 对话 = [[这是怎样的大海啊?汹涌不休，说“是”,接而“不”，一遍又一遍，重复着“不”， 它忧郁地说“是”，却咆哮着，重复说“不”，永无静止.. ..想要我带你去哪呢?
menu
海底迷宫一层 
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='海底迷宫一层' then
        玩家:切换地图(1118, 12, 46)
    end
end



return NPC