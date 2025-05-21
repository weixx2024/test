local NPC = {}
local 对话 = [[
哟西哟西死啦死地！。#89
menu
1|小日本，受死吧
99|我认错人了
]]





function NPC:NPC对话(玩家)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:进入战斗("scripts/war/盛世华夏/狭井槟榔.lua")
    end
end

return NPC
