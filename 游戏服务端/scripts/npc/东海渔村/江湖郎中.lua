local NPC = {}
local 对话 = [[我是专门行走江湖的游方郎中，因为上天有好生之德，我是最喜欢帮助别人的，你看来受伤了，我帮你医治吧。
menu
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
end

return NPC
