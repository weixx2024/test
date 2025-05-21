local NPC = {}
local 对话 = [[
你想去海里啊？想去你就说啊，你不说我怎么知道你想去呢？你虽然很有诚意的看着我，可是，你还是要说你想去的，现在我数一二三，你说你想去哪里？
menu
龙宫
我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '龙宫' then
        玩家:切换地图(1116, 70, 15)
    end
end

function NPC:NPC给予(玩家, cash, items)
end

return NPC