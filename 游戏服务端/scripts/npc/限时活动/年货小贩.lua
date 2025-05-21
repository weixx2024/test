local NPC = {}
local 对话 = [[
所有年货100000两大甩卖了#56要想买得更便宜,可是要凭运气和胆识的哦~走过路过,不要错过#51
menu
1|时间要紧,100000两我买了。
2|我要淘淘
99|听你叫的好玩,来看看
]]





function NPC:NPC对话(玩家)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:取任务("元宵_团员年饭")
        if r then
            r:商店1()
            玩家:购买窗口('scripts/shop/年货小贩.lua')
        else
            return "你身上没有任务！"
        end
    elseif i == '2' then
        local r = 玩家:取任务("元宵_团员年饭")
        if r then
            r:刷新商店()
            玩家:购买窗口('scripts/shop/年货小贩.lua')
        else
            return "你身上没有任务！"
        end
    elseif i == '3' then

    elseif i == '4' then
    end
end

return NPC
