local 战斗 = {}

function 战斗:战斗初始化(玩家, NPC)
    for i = 1, 1 do
        local r = 生成战斗怪物 {
            外形 = NPC.外形,
            名称 = NPC.名称,
            攻击 = 100,
            速度 = 100,
            气血 = 1000,
            是否消失 = true
        }
        self:加入敌方(i, r)
    end
    for i = 2, 7 do
        local r = 生成战斗怪物 {
            外形 = 2005,
            名称 = '帮凶',
            攻击 = 100,
            速度 = 100,
            气血 = 10000,
            是否消失 = true
        }
        self:加入敌方(i, r)
    end
end

function 战斗:战斗回合开始(dt)
end

function 战斗:战斗结束(s)
end

return 战斗
