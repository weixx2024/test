local NPC = {}
local 对话 = [[
你想要离开比武场吗？
menu
1|送我离开
2|点错了
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return 玩家:创建帮战()
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
