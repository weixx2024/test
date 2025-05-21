local NPC = {}
local 对话 = [[
平时都不点我，每次都要给你礼物才来吗#78，要经常来找我玩啊。#44
menu
1|我要领取累计奖励！
2|我要兑换推广奖励
3|我来了解推广规则
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
