local NPC = {}
local 对话 = [[
村子里有个江湖郎中，心肠特好，看病从来不收钱的。你病了也可以去找他啊。
menu
1|我什么都不想做
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
