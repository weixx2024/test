local NPC = {}
local 对话 = [[
我在这里五百年了，只为等待那个她，哎~也不知道对面的那个女孩子见过她了没有....
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
function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end
return NPC
