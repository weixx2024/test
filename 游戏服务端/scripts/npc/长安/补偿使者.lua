local NPC = {}
local 对话 = [[服务器非正常重启，导致领取补偿 。
menu
1|领取补偿
2|我什么都不想做 
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)    
    if i == "1" then
        if 玩家.转生 >= 3 and 玩家.等级 >= 120 then
            if 玩家.补偿领取 == nil or os.date("%j", 玩家.补偿领取) ~= os.date("%j", os.time()) then
                if 玩家:添加物品({
                        生成物品 { 类别 = '道具', 名称 = '清盈果', 参数 = 1000, 数量=5,禁止交易 = true },
                        生成物品 { 类别 = '道具', 名称 = '人形神兽宝卷', 禁止交易 = true },
                    }) then
                    玩家:添加师贡(500000000)
                    玩家:处理补偿()
                    return "你领取了补偿奖励"
                end
            else
                return "你已经领取过了"
            end
        end
    end
end



return NPC