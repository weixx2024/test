-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-26 07:12:31
-- @Last Modified time  : 2022-09-05 19:58:42

local 战斗 = {
    是否惩罚 = false --死亡
}



function 战斗:战斗初始化(玩家)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性
    怪物属性 = {
        外形 = 2121,
        名称 = "二郎神",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 2988,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强封印 = 15,
                忽视抗封 = 10,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
        },
        技能 = {
            { 名称 = "阎罗追命", 熟练度 = 25000 },
            { 名称 = "四面楚歌", 熟练度 = 25000 }
            
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(1, 生成战斗怪物(怪物属性))

    怪物属性 = {
        外形 = 2111,
        名称 = "五叶",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 2988,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 10,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
        },
        技能 = {
            { 名称 = "失心狂乱", 熟练度 = 25000 }
            
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(2, 生成战斗怪物(怪物属性))

    怪物属性 = {
        外形 = 2111,
        名称 = "五叶",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 2988,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 10,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
        },
        技能 = {
            { 名称 = "失心狂乱", 熟练度 = 25000 }
            
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(3, 生成战斗怪物(怪物属性))


    怪物属性 = {
        外形 = 2113,
        名称 = "颜如玉",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 2988,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 13,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
            加强雷 = 30,
                忽视抗雷 = 30,
                加强风 = 30,
                加强火 = 30,
            加强水 = 30,
                忽视抗水 = 30,
        },
        技能 = {
            { 名称 = "天诛地灭", 熟练度 = 25000 },
            { 名称 = "九龙冰封", 熟练度 = 25000 }
            
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(4, 生成战斗怪物(怪物属性))

    怪物属性 = {
        外形 = 2111,
        名称 = "五叶",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 2988,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 13,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
        },
        技能 = {
            { 名称 = "失心狂乱", 熟练度 = 25000 }
            
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(5, 生成战斗怪物(怪物属性))

    怪物属性 = {
        外形 = 2113,
        名称 = "颜如玉",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 2988,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 13,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
            加强雷 = 30,
                忽视抗雷 = 30,
                加强风 = 30,
                加强火 = 30,
            加强水 = 30,
                忽视抗水 = 30
        },
        技能 = {
            { 名称 = "天诛地灭", 熟练度 = 25000 },
            { 名称 = "九龙冰封", 熟练度 = 25000 }
            
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(6, 生成战斗怪物(怪物属性))

    怪物属性 = {
        外形 = 2076,
        名称 = "泾河龙精",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 69000,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 13,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
            加强雷 = 30,
                忽视抗雷 = 20,
                加强风 = 30,
                加强火 = 30,
            加强水 = 30,
                忽视抗水 = 20,
        
        
            连击率 = 75,
            连击次数 = 5,
            致命几率 = 75,
            
            反击率 = 50,
            反击次数 = 1,
            
        },
        内丹 = {
            { 技能 = "暗度陈仓", 转生 = 3, 等级 = 130 },
            { 技能 = "万佛朝宗", 转生 = 3, 等级 = 160 },
        },
        施法几率 = 0,
        是否消失 = false,
    }
    self:加入敌方(7, 生成战斗怪物(怪物属性))

    怪物属性 = {
        外形 = 2113,
        名称 = "颜如玉",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 6900,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 13,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
            加强雷 = 30,
                忽视抗雷 = 30,
                加强风 = 30,
                加强火 = 30,
            加强水 = 30,
                忽视抗水 = 30,
        },
        技能 = {
            { 名称 = "天诛地灭", 熟练度 = 25000 },
            { 名称 = "九龙冰封", 熟练度 = 25000 }
            
        },
        施法几率 = 100,
        是否消失 = false,
    }
    self:加入敌方(8, 生成战斗怪物(怪物属性))


    怪物属性 = {
        外形 = 2076,
        名称 = "泾河龙精",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 69000,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 13,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
            加强雷 = 30,
                忽视抗雷 = 20,
                加强风 = 30,
                加强火 = 30,
            加强水 = 30,
                忽视抗水 = 20,
        
        
            连击率 = 75,
            连击次数 = 5,
            致命几率 = 75,
            
            反击率 = 50,
            反击次数 = 1,
            
        },
        内丹 = {
            { 技能 = "暗度陈仓", 转生 = 3, 等级 = 130 },
            { 技能 = "万佛朝宗", 转生 = 3, 等级 = 160 },
        },
        施法几率 = 0,
        是否消失 = false,
    }
    self:加入敌方(9, 生成战斗怪物(怪物属性))
    怪物属性 = {
        外形 = 2076,
        名称 = "泾河龙精",
        等级 = 等级,
        气血 = 50000000 + 转生 * 80000 + 等级 * 1000,
        魔法 = 2060000 + 等级 * 35,
        攻击 = 69000,
        速度 = 1700,
        抗性 = {
            抗震慑 = 20,
            抗混乱 = 110,
            抗封印 = 120,
            抗昏睡 = 120,
            抗水 = -52,
            抗雷 = -52,
            抗火 = -52,
            抗风 = -52,
                加强混乱 = 20,
                忽视抗混 = 13,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
            加强雷 = 30,
                忽视抗雷 = 20,
                加强风 = 30,
                加强火 = 30,
            加强水 = 30,
                忽视抗水 = 20,
        
        
            连击率 = 75,
            连击次数 = 5,
            致命几率 = 75,
            
            反击率 = 50,
            反击次数 = 1,
            
        },
        内丹 = {
            { 技能 = "暗度陈仓", 转生 = 3, 等级 = 130 },
            { 技能 = "万佛朝宗", 转生 = 3, 等级 = 160 },
        },
        施法几率 = 0,
        是否消失 = false,
    }
    self:加入敌方(10, 生成战斗怪物(怪物属性))




end

--熟练度 l*100
function 战斗:战斗回合开始(v)

end

function 战斗:战斗回合结束(v)

end

function 战斗:战斗开始(v)



end

local function 掉落包(玩家)
    local 大闹积分 = 100000


end

function 战斗:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                掉落包( v.对象.接口)
            end
        end
    end
end

return 战斗
