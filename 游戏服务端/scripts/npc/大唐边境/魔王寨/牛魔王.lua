local NPC = {}
local 对话 = [[
别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
1|我想要回长安
2|算了想想再说
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
function NPC:NPC给予(玩家,cash,items)
    return '你给我什么东西？'
end
return NPC
