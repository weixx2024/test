local NPC = {}
local 对话 = [[
做神仙有什么好？那么多规矩，还是妖怪爽，见谁砍谁，哈哈～！
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
