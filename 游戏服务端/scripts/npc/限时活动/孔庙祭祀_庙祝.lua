local NPC = {}
local 对话 = [[
最近生意不好做,要想想办法。
menu
1|我想买点东西
99|我什么都不想
]]





function NPC:NPC对话(玩家)

    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/庙祝.lua')


    elseif i == '2' then

    end
end

return NPC
