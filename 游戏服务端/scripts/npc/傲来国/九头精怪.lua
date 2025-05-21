local NPC = {}
local 对话 = [[
傲来国方圆五百里常有妖怪出没，当然不全是坏的妖，也有好的妖哦。
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
