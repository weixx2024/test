local NPC = {}
local 对话 = [[
你要合成什么炼妖石。
menu
1|我要合成炼妖
99|我什么也不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:打开窗口("合成炼妖石",玩家.银子)
    end
end

return NPC
