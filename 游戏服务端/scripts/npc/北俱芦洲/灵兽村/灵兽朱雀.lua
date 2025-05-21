local NPC = {}
local 对话 = [[
你找我有什么事。
menu
1|我来领取三坐骑(需战斗)
3|我只是路过看看
]]
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('引导_三坐领取')
    if r then
        return 对话
    end
    return '你找我有什么事？'
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local r = 玩家:进入战斗('scripts/war/三坐骑.lua')
        if r then
            玩家:添加坐骑(生成坐骑 { 种族 = 玩家.种族, 几座 = 3 })
            local rw = 玩家:取任务('引导_三坐领取')
            if rw then
                rw:完成()
            end
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC

                