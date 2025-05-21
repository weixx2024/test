local NPC = {}
local 对话 = [[
大侠，有心上人了吗？你武艺这么高强，心底又好，一定有很多人喜欢吧，来我这里想了解些什么啊？
menu
1|我想了解一些关于结婚的情况
2|我们是来结婚的
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
