local NPC = {}
local 对话 = [[我们宝象国的市场可是西域诸国里面最热闹的，各式商品应有尽有。客人运气好的话，还能淘到些珍稀物件呢!
menu
乌鸡国城外 我什么都不想做
宝象国皇宫
傲来国
洛阳镖局
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='乌鸡国城外' then
        玩家:切换地图(101537, 248, 90)
    elseif i=='宝象国皇宫' then
        玩家:切换地图(101529, 73, 135)
    elseif i=='傲来国' then
        玩家:切换地图(1092, 235, 100)
    elseif i=='洛阳镖局' then
        玩家:切换地图(1236, 331, 169)

    end
end



return NPC