local NPC = {}
local 对话 = [[
我是超级巫医，可以帮你医治召唤兽和增加召唤兽忠诚、喂养坐骑和修理召唤兽饰品。客官，想要做点什么呢？
menu
1|全部医治和修复
2|我的召唤兽宝贝伤得厉害，治疗一下它并提高他的忠诚度吧
3|喂养坐骑
4|帮我修理召唤兽装备（包括饰品）
5|原来你是这样一个医生啊，有需要再找你
]]

function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
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
