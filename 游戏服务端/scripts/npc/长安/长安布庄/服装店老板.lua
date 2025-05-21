local NPC = {}
local 对话 = [[
前两天进了一批绸缎，女孩子们都很喜欢。
menu
1|我想买点东西
99|我什么都不想做]]
local 对话2 = [[
人靠衣装马靠鞍。我们行走江湖的，即使再强悍，穿着破烂，也会被人看扁的#54
menu
3|人靠衣装
99|多谢惠顾
]]
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('新手剧情')
    if r and r.进度 == 11 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安服装店.lua')
    elseif i == '2' then

    end
end

return NPC
