local NPC = {}
local 对话 = [[想去哪里尽管说，给钱就行。
menu
长安桥 陈家村
方寸山 皇宫门口
洛阳 我什么都不想做
洛阳集市
]]
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '长安桥' then
        玩家:切换地图(1001, 251, 91)
    elseif i == '方寸山' then
        玩家:切换地图(1135, 15, 14)
    elseif i == '洛阳' then
        玩家:切换地图(1236, 114, 94)
    elseif i == '洛阳集市' then
        玩家:切换地图(1236, 358, 70)
    elseif i == '陈家村' then
        玩家:切换地图(101538, 179, 74)
    elseif i == '皇宫门口' then
        玩家:切换地图(1001, 301, 251)
    end
end

return NPC
