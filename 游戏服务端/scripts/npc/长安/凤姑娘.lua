local NPC = {}
local 对话 = [[
长安可是个好地方啊，地杰人灵，才子辈出。
]]
local 对话2 = [[
你找我有什么事。
]]
function NPC:NPC对话(玩家, i)
    if 坐骑任务检查(玩家, '引导_六坐领取', '坐骑6_勇往直前') then
        return
    end

    return 对话
end

function NPC:NPC菜单(玩家, i)
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
