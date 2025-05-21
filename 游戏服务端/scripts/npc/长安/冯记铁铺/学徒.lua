local NPC = {}
local 对话 = [[
我已经不在修理装备了，想要在修理装备还是去找冯铁匠吧。
]]

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
