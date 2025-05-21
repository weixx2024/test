local NPC = {}
local 对话 = [[
出家人四大皆空，出家人就家徒四壁，为了表彰各位英雄在水陆大会中精彩表现，化生寺拿出不少宝物，你是来换宝物的吗？
menu
1|兑换奖励
2|我该怎么才能获得水陆功德
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
