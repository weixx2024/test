local NPC = {}
local 对话 = [[
这里的蟠桃可是五百年一开花，五百年一结果，五百年一熟的呀～
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
