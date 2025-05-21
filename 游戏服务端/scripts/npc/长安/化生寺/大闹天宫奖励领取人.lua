local NPC = {}
local 对话 = [[
有一件事，就算是佛祖也不能明白，那就是，当你深深爱着的人儿，却爱上了别人，你要怎么办呢？
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
