local NPC = {}
local 对话 = [[
北俱芦洲有龙窟凤巢二洞，里面盘踞着一群强悍的妖怪。
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
