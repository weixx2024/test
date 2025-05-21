local NPC = {}
local 对话 = [[
在这里好像有个叫黄哥的，听说是打造兵器的能手啊！
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
