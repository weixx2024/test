-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-07-19 06:33:17

local NPC = {}

local 对话 = [[
menu
1|我要进去
99|取消
]]
--"我要领取帮派任务","我来取消帮派任务","离开"
--其它对话
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务("大闹天宫")
    if r and r.阵营 == 2 then
        return 对话
    end
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        玩家:切换地图(101385, 133, 228)
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end
return NPC
