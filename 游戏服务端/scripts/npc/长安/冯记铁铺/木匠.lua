local NPC = {}
local 对话 = [[
孩子不听话，多半是惯的#35没有什么毛病是揍一顿治不了的...如果有，那就揍两顿。#35
menu
3|我什么都不想做
]]
-- 1|我要打造/分解宝宝装备
-- 2|我要重铸宝宝装备
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
