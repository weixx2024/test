local NPC = {}
local 对话 = [[
奢比尸化作人形在本层为所欲为，只要消灭奢比尸就可以顺利通往下一层，奢比尸在（129,63），还请侠士们速去除魔
menu
1|好，等我的好消息
98|待我稍微整理下
]]

local 对话2 = [[
恭喜各位侠士战胜了本层首领―一奢比尸，哈哈，老衲特来道贺。不知侠士愿否继换清除妖魔呢?
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
    if r and r.进度 == 22 then
        return 对话
    elseif r and r.进度 == 24 then
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
    if r == nil then
        return
    end
    if r then
        if i == "1" then
            if r.进度 == 22 then
                r:改变进度(23)
                return '速去消灭奢比尸,小心沿途的妖魔'
            end
        elseif i == "2" then
            r:进场(玩家, 6)
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
