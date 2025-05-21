
local NPC = {}
local 对话 = [[
上次算你们走运，完成了我的考验才放你们一马。这次竟敢来找死,那就休怪本尊下手狠#132
menu
1|废话少说,还不速速离去(战斗)
99|离开
]]





function NPC:NPC对话(玩家)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local r = 玩家:取任务('日常_大雁塔副本')
        if r.进度 == 9 then
            local sf = 玩家:进入战斗("scripts/war/大雁塔/大雁塔_2.lua")
            if sf then
                r:完成二层(玩家)
            end
        end
    end

end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
