local NPC = {}
local 对话 = [[
现在的年轻人动不动就离婚，月老很生气，后果很严重。
menu
1|日子没法过了，我要离婚!
2|我只是路过看看
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
