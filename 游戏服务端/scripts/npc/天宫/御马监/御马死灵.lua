local NPC = {}
local 对话 = [[
我们这里是专门饲养神马的。
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)

end

return NPC
