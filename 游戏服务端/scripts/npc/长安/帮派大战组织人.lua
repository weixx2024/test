local NPC = {}
local 对话 = [[
我这可以将你传送到帮战比武场，需要进去吗？
menu
1|进入龙神比武场
90|帮战积分兑换
99|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return 玩家:龙神帮战入场()
    elseif i == '90' then
        玩家:购买窗口('scripts/shop/积分_帮战.lua', '帮战积分')
    end
end

return NPC
