local NPC = {}
local 对话 = [[
妖魔多为阴险狡诈之辈,我在本层降妖途中，不慎将镇压着本层首领的宝物一--聚魄画轴遗失，怀疑是本层妖魔所为，侠士可愿为我寻回这宝物?
menu
1|路不拾遗乃侠士所为,交给我了
98|我要整顿下队伍先,稍等
]]
local 对话2 = [[
快士莫非害怕了本层的妖魔?
menu
2|归还画轴
3|人手不够我要去叫点兄弟
98|暂时迷路了
]]
local 对话3 = [[
我已经除掉了这层的妖魔首领,快送我去下一层。
menu
4|进入下一层
98|我再逛会,看看有没有落网的妖怪。
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
    if r.进度 == 5 then
        return 对话
    elseif r.进度 == 7 then
        return 对话2
    elseif r.进度 == 10 then
        return 对话3
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
            if r.进度 == 5 then
                r:改变进度(6)
                return '请快去帮老衲寻找画铀吧'
            end
        elseif i == "2" then
            if r.进度 == 7 then
                r:改变进度(8)
                return string.format(' 太感谢你了,本层的妖魔首领就在这幅画轴中，侠士请火速去(%s,%s)打开画轴牧服妖质。'
                , r.X, r.Y)
            end
        elseif i == "3" then --离场
        elseif i == "4" then --离场
            r:进场(玩家, 3)
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
