-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-07-19 06:33:17

local NPC = {}
local 对话 = [[
漫漫百年,一人难免孤寂。你们愿与我聊聊么？
menu
1|愿意。
2|查看评分
99|罢了
]]
--其它对话
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('日常_孤竹城')
    if r then
        return 对话
    end
    return "你身上没有任务"
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local r = 玩家:取任务('日常_孤竹城')
        if r  then
            local 进入时间 = os.time()
            local rr = 玩家:进入战斗("scripts/war/孤竹城/爱离别苦.lua")
            if rr then
                r:完成关卡(玩家,6,进入时间)
            end
        end
    elseif i == "2" then
        local r = 玩家:取任务('日常_孤竹城')
        if r then
            return r:取评分(6)
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC