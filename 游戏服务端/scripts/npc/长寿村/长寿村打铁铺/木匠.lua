local NPC = {}
local 对话 = [[
可惜，没有三界灵石再好的材料也难发挥作用啊！
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
