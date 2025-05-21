-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-07-19 06:33:17

local NPC = {}
local 对话2 = [[
menu
1|到对方基地
2|回自己基地
99|离开
]]

local 对话 = [[
menu
3|攻击箭塔
99|离开
]]

function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务("大闹天宫")
    if r and r.阵营 == 2 then
        if 取箭塔耐久_大闹("花果山", 1) > 0 then
            return 对话
        else
            return 对话2
        end
    end
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then

    elseif i == "2" then

    elseif i == "3" then
        local r = 玩家:取任务("大闹天宫")
        if r and r.阵营 == 2 then
            local sf = 1
        end
    end




end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
