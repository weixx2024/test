local NPC = {}
local 对话 = [[
还真是麻烦，三尸神及其弟子给老衲施展了咒语,老衲动弹不得,快士可否帮忙消灭之?只需消灭,老衲方可脱身，将其封印。它们现在在(19,21)处,侠士们速去铲除
menu
1|好,等我的好消息
98|待我稍徵整理下
]]

local 对话2 = [[
阿弥陀佛,这世上诸多妖质鬼怪,怎能一网打尽。佛我本同,众生皆有佛性。若想除黄，务必一心向善,存佛心、做事,善哉善哉
menu
2|进入下一层
98|有点怕,叫我喝口酒
]]

local _对话 = [[
阿弥陀佛,这世上诸多妖质鬼怪,怎能一网打尽。佛我本同,众生皆有佛性。若想除黄，务必一心向善,存佛心、做事,善哉善哉
menu
98|我要整顿下队伍先,稍等
]]

function NPC:NPC对话(玩家)
    local r = 玩家:取任务('日常_大雁塔副本')
    if r == nil then
        return
    end
    if r.进度 == 28 then
        return 对话
    elseif r.进度 == 4 then
        return 对话2
    end
    return _对话
end

function NPC:NPC菜单(玩家, i)
    if i == '98' then
        玩家:切换地图(1001, 103, 199)
        return
    end

    local r = 玩家:取任务('日常_大雁塔副本')
    if r then
        if i == "1" then
            if r.进度 == 28 then
                r:改变进度(29)
                return '速去消灭三尸神,小心沿途的妖魔'
            end
        elseif i == "2" then

        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
