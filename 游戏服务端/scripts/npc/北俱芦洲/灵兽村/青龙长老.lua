local NPC = {}
local 对话 = [[
你找我有什么事。
menu
1|我来领取二坐骑(需战斗)
3|我只是路过看看
]]
function NPC:NPC对话(玩家, i)
    if 坐骑任务检查(玩家, '引导_二坐领取', '坐骑2_惩恶扬善') then
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
