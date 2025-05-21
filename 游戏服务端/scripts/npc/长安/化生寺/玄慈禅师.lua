local NPC = {}
local 对话 = [[
诸佛神力，如是无量无边，不可思议。若我以是神力，于无量无边百千万亿阿僧祗劫，为嘱累故，说此经功德，犹不能尽。佛法功德，在乎于心，念世间疾苦，度百般慈悲！
menu
1|晚来无事，我来聆听尊者佛说
2|佛君，我来沉寂自修（离线修元）
3|如何潜修佛缘
4|佛缘慈悲，我来换点东西
5|暂无兴趣，告辞
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
