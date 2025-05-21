local NPC = {}
local 对话 = [[
在我这里存放物品，绝对安全，童叟无欺。只不过，不过...客官在本店每次取回物品，小的将会收取您25两作为劳力费#17
menu
1|我想看看我当铺里有什么东西
2|给我当铺增加物品栏（1000000两）
3|你是干嘛的？
4|离开
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:当铺窗口()
    end
end

return NPC
