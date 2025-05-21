local NPC = {}
local 对话 = [[
我是本服国库总管，我主要负责奖励领取。
menu
1|我要领取个人奖励
2|我要用军功换取奖励
3|离开
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
