-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-07-19 06:33:17

local NPC = {}
local 对话 = [[
这姑苏城不生死，百年如一日，着实冷清呢。
menu
1|我要出去
99|罢了
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        玩家:切换地图(101538, 152, 129) 
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
