local NPC = {}
local 对话 = [[
名字代表一个人的身份和象征，没有什么特别情况，是万不可随意更改的。本官这里可以付费修改名字，需要付出一点手续费而已，你现在是否需要改名字呢？
menu
1|查询曾用名
2|我要付费修改名字
3|定制专有徽章
4|我只是路过看看
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
