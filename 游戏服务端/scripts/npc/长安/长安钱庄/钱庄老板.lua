local NPC = {}
local 对话 = [[
恭喜发财这里是最大的连锁钱庄，提供零存整取，整存零取，存钱不取，不存不取等多项服务，另外还有保险箱特殊服务!客官，想做点什么?
menu
1|我的钱太多了，想存起来
2|我没有钱花了，想把存款拿出来
3|我想设置我的交易锁状态
99|我只是路过看看
]]


local 对话2 = [[
恭喜发财这里是最大的连锁钱庄，提供零存整取，整存零取，存钱不取，不存不取等多项服务，另外还有保险箱特殊服务!客官，想做点什么?
menu
1|我想解除交易锁
2|我要锁定交易
99|我只是路过看看
]]




function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:打开窗口("存款")
    elseif i == '2' then
        玩家:打开窗口("取款")
    elseif i == '3' then
        local r = 玩家:选择窗口(对话2)
        if r == "1" then
            local rr = 玩家:输入窗口("", "请输入解锁密码")
            if rr == 玩家.安全码 then
                玩家:置交易锁(false)
                return "你关闭了交易锁"
            else
                return "请输入正确的安全码"
            end
        elseif r == "2" then
            if rr == 玩家.安全码 then
                玩家:置交易锁(true)
                return "你开启了交易锁"
            else
                return "请输入正确的安全码"
            end
        end






    elseif i == '4' then
    end
end

return NPC
