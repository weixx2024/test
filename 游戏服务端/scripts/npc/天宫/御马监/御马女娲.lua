local NPC = {}
local 对话 = [[
这里的神马可厉害了，能腾云驾雾，行走三界中啊！
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)

end

return NPC
