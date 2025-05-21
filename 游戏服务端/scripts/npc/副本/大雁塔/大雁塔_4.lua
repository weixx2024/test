local NPC = {}
local 对话 = [[
本层妖魔首领以显形，只要击败首领就可以顺利通往下一层，小心路上的游荡妖魔，他们可是会主动攻击的，若施主能施展神行技能，倒是个不错的躲避方法
menu
1|好，等我的好消息
98|等我施展神行先
]]

local 对话2 = [[
恭喜各位侠士战胜了本层首领——巫支祁，哈哈，老衲特来道贺。不知侠士愿否继续清楚妖魔呢？
menu
2|当然愿意，送我上去
98|待我稍微整理下
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
    if r.进度 == 19 then
        return 对话
    elseif r.进度 >= 21 then
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
            if r.进度 == 19 then
                r:改变进度(20)
                return '速去消灭巫支祁，小心沿途的妖怪'
            end
        elseif i == "2" then
            r:进场(玩家, 5)
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
