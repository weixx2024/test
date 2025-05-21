local NPC = {}
local 对话 = [[
恭喜发财这里是最大的连锁钱庄，提供零存整取，整存零取，存钱不取，不存不取等多项服务，另外还有保险箱特殊服务！客官想做点什么呢？
menu
1|我想设定我的钱庄加锁状态
2|查看我的保险箱
3|我的钱太多了，想存起来
4|我没有钱花了，想把存款拿出来
5|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
