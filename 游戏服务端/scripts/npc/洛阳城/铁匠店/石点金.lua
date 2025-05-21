local NPC = {}
local 对话 = [[
洛阳有的时候比京城还热闹呢。
menu
1|我想合成宝石
99|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:打开窗口("宝石合成",玩家.银子)
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
