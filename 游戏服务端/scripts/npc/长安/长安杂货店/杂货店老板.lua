local NPC = { 队伍对话 = true }
local 对话 = [[
有钱的人就横，这世界上哪儿都是这样。
menu
1|我想买点东西
2|高级道具
3|剧情道具
99|我什么都不想做]]
local 对话2 = [[
礼物都是一位高人帮你挑选的，看看你能用的上不#50
menu
2|杂货店的礼物（请预备两个空格）
99|多谢惠顾]]


function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('新手剧情')
    if r and r.进度 == 12 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安杂货店.lua')
    elseif i == '2' then
        玩家:购买窗口('scripts/shop/长安杂货店_高级.lua')
    elseif i == '3' then
        玩家:购买窗口('scripts/shop/长安杂货店_剧情.lua')
    end
end

return NPC
