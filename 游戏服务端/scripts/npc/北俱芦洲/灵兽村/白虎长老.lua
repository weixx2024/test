local NPC = {}
local 对话 = [[
你找我有什么事。
]]
function NPC:NPC对话(玩家, i)
    if 坐骑任务检查(玩家, '引导_四坐领取', '坐骑4_锲而不舍') then
        return
    end

    return '你找我有什么事？'
end

function NPC:NPC菜单(玩家, i)
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
