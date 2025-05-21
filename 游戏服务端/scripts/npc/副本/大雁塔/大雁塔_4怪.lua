
local NPC = {}
local 对话 = [[
终于等到了你，本层的小妖已尽数被我收服,可这妖魔首领却法力高强，快士，快章上这块镇妖镜，去和你的同伴合阵铲除本层的妖贤百领吧。
menu
1|好,快给我镜子
99|等会,先等我喝酒壮胆
]]





function NPC:NPC对话(玩家)
    local r = 玩家:取任务('日常_大雁塔副本')
    if r.进度 == 20 then
        local rr = 玩家:进入战斗("scripts/war/大雁塔/大雁塔_4.lua")
        if rr then
            r:完成四层(玩家)
        end
    end
end

function NPC:NPC菜单(玩家, i)


end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
