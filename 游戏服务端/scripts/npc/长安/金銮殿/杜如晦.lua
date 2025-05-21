local NPC = {}
local 对话 = [[
天下太平，极盛之时，身无长技，何以养家？我可以介绍合适的师傅与你，阁下意下如何？
menu
1|明白了，我要挑选一个职业
2|我想换个职业
3|职业是什么
4|离开
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
