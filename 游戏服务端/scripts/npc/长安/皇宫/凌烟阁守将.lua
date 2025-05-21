local NPC = {}
local 对话 = [[
凌烟阁地宫被妖魔占据，皇上以我大唐二十四功臣画像悬于凌烟阁镇压，遏制这些妖魔出世，但要扫除这些妖魔永绝后患，还需天下豪杰之力。英雄！你愿意担起这个重任吗？
menu
1|进入地宫
2|了解地宫情况
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1291, 78, 67)
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
