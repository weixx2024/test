local NPC = {}
local 对话 = [[
正所谓天下兴亡，匹夫有责，朝廷近日公务繁忙，众位侠士可有心为国分忧？
menu
1|吾等正有此意
2|我想取消任务
3|我什么都不想做
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
