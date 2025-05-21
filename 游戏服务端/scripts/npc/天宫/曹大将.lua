local NPC = {}
local 对话 = [[
如果你的召唤兽没有第二抗性的话，我可以帮忙给你的召唤兽添加上去。
menu
1|我要为我的召唤兽添加第二抗性
2|我想让召唤兽重新领悟一项初始技能（20万）
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
