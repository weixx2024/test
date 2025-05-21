local NPC = {}
local 对话 = [[
我可以帮你把多个召唤兽经验丹或内丹经验丹炼制合成为一个，开炉费就免了！
menu
1|合成
2|离开
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
