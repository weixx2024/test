local NPC = {}
local 对话 = [[镇元大仙不收我为徒，我就天天在这呆着，直到他被我的行为感动，顺便送你一程吧。
menu
大唐边境
万寿山
洛阳集市
我什么都不想做
]]
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '大唐边境' then
        玩家:切换地图(1173, 177, 149)
    elseif i == '万寿山' then
        玩家:切换地图(101299, 35, 98)
    elseif i == '洛阳集市' then
        玩家:切换地图(1236, 355, 66)
    end
end

return NPC
