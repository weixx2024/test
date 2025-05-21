local NPC = {}
local 对话 = [[
我是负责作坊的总管,在我这里可以加入和脱离作坊，也可以向我请教熟练度来提升等级
menu
1|看看你能干些啥
2|只是随便看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:作坊总管窗口()
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
