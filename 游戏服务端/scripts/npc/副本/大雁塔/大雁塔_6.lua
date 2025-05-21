local NPC = {}
local 对话 = [[
真没想到,妖魔的能力竟然强大到请来了4大护法来助其为虐。青龙，白虎，朱雀,玄武,还直是麻烦,贫僧也看不透本层的玄机了。
现烛九阴正在本层为所欲为，快士只需消灾,即可通往下一层，首领正在(48,55)、还请侠士们速去铲除。
menu
1|好,等我的好消息
98|待我稍徵整理下
]]

local 对话2 = [[
恭喜各位侠士战胜了本层首领――烛九阴,哈哈，老衲特来道贺。不知快士愿否继续清除妖怪呢?
menu
2|这个必然,送我上去
98|待我稍徵整理下
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
    if r.进度 == 25 then
        return 对话
    elseif r.进度 == 27 then
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
            if r.进度 == 25 then
                r:改变进度(26)
                return '烛九阴正在本层为所欲为，快士只需消灭即可通往下一层，首领正在(48,55)，还请侠士们速去铲除。'
            end
        elseif i == "2" then
            if r.进度 == 27 then
                r:进场(玩家, 7)
            end
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
