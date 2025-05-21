local NPC = {}
local 对话 = [["东临碣石，以观沧海，水何澹澹，山岛竦峙.....想要去哪里呢?"
menu
1|东海渔村
2|长安桥
3|江州
99|我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1208, 24, 52)
    elseif i == '2' then
        玩家:切换地图(1001, 248, 94)
    elseif i == '3' then
        玩家:切换地图(1110, 474, 78)
    end
end

return NPC
