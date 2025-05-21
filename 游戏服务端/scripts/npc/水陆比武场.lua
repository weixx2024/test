
local NPC = {}
local 对话 = [[你找我有什么事。
menu
1|我要离场
99|什么都不想做
]]
--"我要领取帮派任务","我来取消帮派任务","离开"
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)

    if i == '1' then
        玩家:切换地图(1003, 115, 42)
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
