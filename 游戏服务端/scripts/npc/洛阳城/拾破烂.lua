local NPC = {}
local 对话 = [[
收纸板~~~报纸~~~废铜~~~烂铁~~~~~~
menu
1|我要卖点东西
2|我什么都不想做
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
