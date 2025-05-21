local NPC = {}
local 对话 = [[
小隐隐于野，中隐隐于市，大隐隐于朝。阁下想修理装备吗？
menu
1|确认修理
2|查看修理详情
3|我要修理物品栏装备
4|我只是路过看看]]

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
