local NPC = {}
local 对话 = [[
光华流淌，这里传来一阵波动；从这里可以回到移山大殿。
menu
1|我要进入
2|前途渺渺，我还是在准备下吧
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
