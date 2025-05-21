local NPC = {}
local 对话 = [[
本官专门为跟别人有新仇旧恨的人士发挑战书，发挑战书需要派遣手下送信，所以每次发挑战书都要收取一定的手续费。
menu
1|帮我写挑战书
2|我要接受对方的挑战
3|我想知道更多细节
4|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:打开窗口("皇宫挑战")
    elseif i == '2' then
        if not 玩家.其它.皇宫挑战 then return end
        玩家.其它.皇宫挑战.接受 = true
        if 玩家.其它.皇宫挑战.银子 and 玩家.其它.皇宫挑战.银子 > 0 then
            玩家:扣除银子(玩家.其它.皇宫挑战.银子)
        end
        玩家:常规提示("#Y接受了对方的挑战书。")
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
