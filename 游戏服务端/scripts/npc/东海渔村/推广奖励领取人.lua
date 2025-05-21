local NPC = {}
local 对话 = [[
输入你的推广码，即可获得相应奖励.
menu
1|输入推广码

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
