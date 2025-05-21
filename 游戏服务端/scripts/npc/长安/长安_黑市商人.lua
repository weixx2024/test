local NPC = {}
local 对话 = [[瞧一瞧看一看，只需要给我点东西就能换走。
menu
1|我看看
2|我什么都不想做 
]]

-- 其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i == "1" then
        玩家:打开窗口("物品兑换")
    end
end

return NPC