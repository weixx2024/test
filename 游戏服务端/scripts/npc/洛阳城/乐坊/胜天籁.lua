local NPC = {}
local 对话 = [[
闲坐夜明月，幽人弹素琴。
menu
1|我要撰写秘籍
4|我只是路过看看
]]
local 对话2 = [[
闲坐夜明月，幽人弹素琴。
menu
1|步摇坊
2|湛卢坊
3|七巧坊
4|生莲坊
5|同心坊
99|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if 玩家.体力 < 10 then
            return "需要10点体力"
        elseif 玩家.银子 < 100000 then
            return "需要10W两银子"
        end
        local r = 玩家:选择窗口(对话2)
        if r and r + 0 <= 5 then
            local t = 玩家:取作坊数据(r + 0)
            if t then
                if t.段位 < 7 then
                    return "达到7段才可以撰写秘籍"
                end
                local mj = 生成物品 { 名称 = "作坊秘籍", 数量 = 1, 作坊 = r + 0, 作者 = 玩家.名称,
                    段位 = t.段位,
                    等级 = t.等级, 熟练 = t.熟练度 }
                if mj then
                    if 玩家:添加物品({ mj }) then
                        玩家:扣除银子(100000)
                        玩家:扣除体力(10)
                    end
                    
                end
            end
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
