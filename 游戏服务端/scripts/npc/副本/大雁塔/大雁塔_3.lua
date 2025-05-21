local NPC = {}
local 对话 = [[
万物皆有五行,这五种元素相生相克，使万物循环不已。这层的首领更加狡猾，竟然布下了五行阵而惹匿其中，侠士，只有赢除五行阵万能见到怪物真身,#R记住:金克木，木克土，土克水，水克火，火克金!#W那么破除五行阵就先从#G火妖#W开始吧。
menu
1|看我来破这五行阵
98|等会，我还没搞明白
]]

local 对话2 = [[
感谢侠士为天下苍生所傲的一切,后面的路就要全靠你们自己了，前方妖魔法力强大,老衲怕自己再没有能力来帮助各位侠士祝各位好运。
menu
2|多谢提醒,送我上去先
98|内急，稍等啊
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
    if r.进度 == 11 then
        return 对话
    elseif r.进度 == 18 then
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
            if r.进度 == 11 then
                r:改变进度(12)
                return "速速破除五行阵,消灭妖魔。"
            end
        elseif i == "2" then
            r:进场(玩家, 4)
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
