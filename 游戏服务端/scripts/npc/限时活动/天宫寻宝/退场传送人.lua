local NPC = {}

local 对话 = [[
可寻到心意的宝物？
menu
1|我要离场
99|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1208, 56, 109)
    end
end

function NPC:NPC给予(玩家, cash, items)
end

return NPC
