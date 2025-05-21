
local NPC = {}
local 对话 = [[
金克木,木克土,土克水,水克火,火克金,相生相克,生生不息。
menu
1|就是你了,看我来破你这五行阵
99|手抖点错了
]]





function NPC:NPC对话(玩家)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local r = 玩家:取任务('日常_大雁塔副本')
        if r.进度 == 12 then
            local sf = 玩家:进入战斗("scripts/war/大雁塔/大雁塔_3火.lua")
            if sf then
                r:改变进度(13)
                玩家:常规提示("#Y你们战胜了火妖,快去破除下一个阵眼")
            end
        end
    end

end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
