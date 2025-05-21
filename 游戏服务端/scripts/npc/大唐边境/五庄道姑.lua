local NPC = {}
local 对话 = [[为什么镇元大仙不收女徒弟呢，我可是非常想学他的法术的，帮我问问好吗?我可以带你去他的五庄观。
menu
1|五庄观
99|我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1146, 20, 16)
    end
end

return NPC
