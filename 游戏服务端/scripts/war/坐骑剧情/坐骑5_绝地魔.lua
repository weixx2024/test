local 战斗 = {}

function 战斗:战斗初始化(玩家, NPC)
    for i = 1, 1 do
        local r = 生成战斗怪物 {
            外形 = NPC.外形,
            名称 = NPC.名称,
            气血 = 800000,
            魔法 = 300000,
            攻击 = 12800,
            速度 = 1120,
            抗性 = {
                抗混乱 = 60,
                抗封印 = 60,
                抗昏睡 = 40,
                抗中毒 = 40,
                抗风 = 35,
                抗火 = 35,
                抗水 = 35,
                抗雷 = 35,
                加强混乱 = 8,
                加强封印 = 8,
                加强昏睡 = 8,
                忽视抗混 = 4,
                忽视抗印 = 4,
                忽视抗睡 = 4,
                加强毒 = 44,
                忽视抗毒 = 26,
                抗震慑 = 10,
                物理吸收 = 55,
                躲闪率 = 25,
            },
            技能 = {
                { 名称 = "阎罗追命", 熟练度 = 10000 },
                { 名称 = "万毒攻心", 熟练度 = 10000 },
                { 名称 = "百日眠", 熟练度 = 10000 },
                { 名称 = "失心狂乱", 熟练度 = 10000 },
                { 名称 = "天诛地灭", 熟练度 = 10000 },
            },
            施法几率 = 60,
            是否消失 = true
        }
        self:加入敌方(i, r)
    end
    for i = 2, 5 do
        local r = 生成战斗怪物 {
            外形 = 2108,
            名称 = '绝天',
            气血 = 3300000,
            魔法 = 300000,
            攻击 = 12800,
            速度 = 920,
            抗性 = {
                抗混乱 = 100,
                抗封印 = 100,
                抗昏睡 = 90,
                抗中毒 = 40,
                抗风 = 35,
                抗火 = 35,
                抗水 = 35,
                抗雷 = 35,
                加强混乱 = 8,
                加强封印 = 8,
                加强昏睡 = 8,
                忽视抗混 = 4,
                忽视抗印 = 4,
                忽视抗睡 = 4,
                加强毒 = 44,
                忽视抗毒 = 26,
                抗震慑 = 10,
                物理吸收 = 55,
                躲闪率 = 25,
            },
            技能 = {
                { 名称 = "阎罗追命", 熟练度 = 10000 },
                { 名称 = "万毒攻心", 熟练度 = 10000 },
                { 名称 = "百日眠", 熟练度 = 10000 },
                { 名称 = "失心狂乱", 熟练度 = 10000 },
                { 名称 = "天诛地灭", 熟练度 = 10000 },
            },
            施法几率 = 60,
            是否消失 = true
        }
        self:加入敌方(i, r)
    end
    for i = 6, 8 do
        local r = 生成战斗怪物 {
            外形 = 2110,
            名称 = '绝地',
            气血 = 3300000,
            魔法 = 300000,
            攻击 = 12800,
            速度 = 920,
            抗性 = {
                抗混乱 = 100,
                抗封印 = 100,
                抗昏睡 = 90,
                抗中毒 = 40,
                抗风 = 35,
                抗火 = 35,
                抗水 = 35,
                抗雷 = 35,
                加强混乱 = 8,
                加强封印 = 8,
                加强昏睡 = 8,
                忽视抗混 = 4,
                忽视抗印 = 4,
                忽视抗睡 = 4,
                加强毒 = 44,
                忽视抗毒 = 26,
                抗震慑 = 10,
                物理吸收 = 55,
                躲闪率 = 25,
            },
            技能 = {
                { 名称 = "阎罗追命", 熟练度 = 10000 },
                { 名称 = "万毒攻心", 熟练度 = 10000 },
                { 名称 = "百日眠", 熟练度 = 10000 },
                { 名称 = "失心狂乱", 熟练度 = 10000 },
                { 名称 = "天诛地灭", 熟练度 = 10000 },
            },
            施法几率 = 60,
            是否消失 = true
        }
        self:加入敌方(i, r)
    end
    for i = 9, 10 do
        local r = 生成战斗怪物 {
            外形 = 2109,
            名称 = '绝魔',
            气血 = 3300000,
            魔法 = 300000,
            攻击 = 32800,
            速度 = 820,
            抗性 = {
                抗混乱 = 100,
                抗封印 = 100,
                抗昏睡 = 90,
                抗中毒 = 40,
                抗风 = 35,
                抗火 = 35,
                抗水 = 35,
                抗雷 = 35,
                加强混乱 = 8,
                加强封印 = 8,
                加强昏睡 = 8,
                忽视抗混 = 4,
                忽视抗印 = 4,
                忽视抗睡 = 4,
                加强毒 = 44,
                忽视抗毒 = 26,
                抗震慑 = 10,
                物理吸收 = 55,
                躲闪率 = 25,
            },
            技能 = {
                { 名称 = "阎罗追命", 熟练度 = 10000 },
                { 名称 = "万毒攻心", 熟练度 = 10000 },
                { 名称 = "百日眠", 熟练度 = 10000 },
                { 名称 = "失心狂乱", 熟练度 = 10000 },
                { 名称 = "天诛地灭", 熟练度 = 10000 },
            },
            施法几率 = 60,
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
