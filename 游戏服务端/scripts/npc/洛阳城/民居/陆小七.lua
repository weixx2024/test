local NPC = {}
local 对话 = [[
洛阳和长安离得不远，我经常去长安看望我的朋友王秀才。
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
