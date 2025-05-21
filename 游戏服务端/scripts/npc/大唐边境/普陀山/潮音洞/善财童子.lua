local NPC = {}
local 对话 = [[
离离原上草，一岁一枯荣。野火烧不尽，春风吹又生。我来领养一个孩子
menu
1|我要领养一个男孩
2|我想领养一个女孩
3|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:添加孩子(生成孩子 { 性别 = 1 })
    elseif i == '2' then
        玩家:添加孩子(生成孩子 { 性别 = 2 })
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
