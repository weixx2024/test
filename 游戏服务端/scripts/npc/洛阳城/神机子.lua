local NPC = {}
local 对话 = [[
老夫退出江湖多年了，世事纷乱，天机难测，凡事须多小心。
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
