local NPC = {}
local 对话 = [[
当你有了师徒积分，可以来我这里兑换
menu
1|我想兑换师徒奖励
2|师徒积分是什么
3|我只是路过看看
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
