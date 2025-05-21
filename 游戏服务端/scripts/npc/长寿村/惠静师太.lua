local NPC = {}
local 对话 = [[
长寿村乃一仙家宝地，村内居民只活百八十岁那叫短命的了。
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
