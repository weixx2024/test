local NPC = {}
local 对话 = [[
你们想挑战我？不怕我手中的七巧玲珑塔么？
]]
local 对话2 = [[
你们想挑战我？不怕我手中的七巧玲珑塔么？
menu
1|饱汉不知饿汉饥！来打！
2|算了算了，不和你打
]]
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务("为爱逆天")
    if r and r.进度 == 3 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        -- local t = {}
        -- if not 玩家.是否队长 then
        --     return "该任务需要组队参加"
        -- end
        -- if 玩家:取队伍人数() < 5 then
        --     return "该任务需要5人参加"
        -- end

        -- for _, v in 玩家:遍历队伍() do
        --     if v:判断等级是否低于(90) then
        --         table.insert(t, v.名称)
        --     end
        -- end

        -- if #t > 0 then
        --     return table.concat(t, '、 ') .. '#W低于90级,无法挑战该任务!'
        -- end

        local r = 玩家:取任务("为爱逆天")
        if r and r.进度 == 3 then
            local sf = 玩家:进入战斗('scripts/war/限时活动/为爱逆天/天王李靖.lua', self)
            if sf then
                return '小子,有本事到大闹天宫走一走，看看你的本事有多大#04'
            end
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
