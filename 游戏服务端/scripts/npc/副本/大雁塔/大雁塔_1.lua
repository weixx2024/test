local NPC = {}
local 对话 = [[
终于等到了你，本层的小妖已尽数被我收服,可这妖魔首领却法力高强，快士，快章上这块镇妖镜，去和你的同伴合阵铲除本层的妖贤百领吧。
menu
1|好,快给我镜子
98|等会,先等我喝酒壮胆
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
    if r.进度 == 1 then
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
            if r.进度 == 1 then
                if r:获取镜子(玩家) then
                    return '队长得到了镇妖镜，速速离队到达指定位嚣组阵除妖'
                else
                    return '你身上没有空余的道具栏'
                end
            end
        elseif i == "2" then
            r:进场(玩家, 2)
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
