local NPC = {}
local 对话 = [[
天气热了，真想好好去喝一杯......
menu
1|我想用银子买点东西
9|我只是路过看看
]]
local 对话2 = [[
我们的生命会不会过保质期？如果有，一定要善待自己啊#53
menu
3|我身体很好！
4|没事，路过而已
]]
function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
    local r = 玩家:取任务('新手剧情')
    if r and r.进度 == 9 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安药店.lua')
    elseif i == '2' then
    end
end

return NPC