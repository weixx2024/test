local NPC = {}
local 对话 = [[
当今国泰民安，四海升平，大王在此举行比武大会，选拔能人异士保家卫国，如果对自己的能力有信心，可以参加我特别举办的军事对战演习。
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
