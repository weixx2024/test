local NPC = {}
local 对话 = [[别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
我想要回长安
]]
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '我想要回长安' then
        玩家:切换地图(1001, 332, 24)
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
