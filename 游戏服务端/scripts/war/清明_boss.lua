-- @Autho  : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-26 07:12:31
-- @Last Modified time  : 2022-08-01 13:05:50

local 战斗 = {
    是否惩罚 = false --死亡
}

local _怪物 = {
    { 名称 = "阎罗王", 外形 = 2075,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 200000 + 等级 * 5000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 21811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(50, 100) + 转生 * 50 + 等级 * 1
        end,
        抗性 = { 抗水 = -39.7, 抗雷 = -39.7, 抗火 = -39.7, 抗风 = -39.7, 抗鬼火 = -30, 抗震慑 = 31 },
        技能 = { { 名称 = "天诛地灭", 熟练度 = 18000 } },
        施法几率 = 50,
        是否消失 = false,
    },
    { 名称 = "白无常", 外形 = 3058,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 200000 + 等级 * 5000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 21811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(50, 100) + 转生 * 50 + 等级 * 1
        end,
        抗性 = { 抗水 = -39.7, 抗雷 = -39.7, 抗火 = -39.7, 抗风 = -39.7, 抗鬼火 = -30, 抗震慑 = 31 },
        技能 = { { 名称 = "天诛地灭", 熟练度 = 18000 } },
        施法几率 = 50,
        是否消失 = false,
    },
    { 名称 = "黑无常", 外形 = 3073,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 200000 + 等级 * 5000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 21811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(50, 100) + 转生 * 50 + 等级 * 1
        end,
        抗性 = { 抗水 = -39.7, 抗雷 = -39.7, 抗火 = -39.7, 抗风 = -39.7, 抗鬼火 = -30, 抗震慑 = 31 },
        技能 = { { 名称 = "天诛地灭", 熟练度 = 18000 } },
        施法几率 = 50,
        是否消失 = false,
    },
    { 名称 = "牛头", 外形 = 2052,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 200000 + 等级 * 5000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 21811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(50, 100) + 转生 * 50 + 等级 * 1
        end,
        抗性 = { 抗水 = -39.7, 抗雷 = -39.7, 抗火 = -39.7, 抗风 = -39.7, 抗鬼火 = -30, 抗震慑 = 31 },
        技能 = { { 名称 = "天诛地灭", 熟练度 = 18000 } },
        施法几率 = 50,
        是否消失 = false,
    },
    { 名称 = "马面", 外形 = 2053,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 200000 + 等级 * 5000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 21811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(50, 100) + 转生 * 50 + 等级 * 1
        end,
        抗性 = { 抗水 = -39.7, 抗雷 = -39.7, 抗火 = -39.7, 抗风 = -39.7, 抗鬼火 = -30, 抗震慑 = 31 },
        技能 = { { 名称 = "天诛地灭", 熟练度 = 18000 } },
        施法几率 = 50,
        是否消失 = false,
    },
}


local _判官 = {
    { 名称 = "转轮王", 外形 = 2282,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },
    { 名称 = "平等王", 外形 = 2278,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },
    { 名称 = "初江王", 外形 = 2275,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },
    { 名称 = "秦广王", 外形 = 2274,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },
    { 名称 = "都市王", 外形 = 2280,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },
    { 名称 = "泰山王", 外形 = 2279,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },
    { 名称 = "宋帝王", 外形 = 2276,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },
    { 名称 = "卞城王", 外形 = 2281,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },
    { 名称 = "杵官王", 外形 = 2277,
        气血 = function(等级, 转生)
            return 100001 + 转生 * 100000 + 等级 * 3000
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 2988 + 11811 * 转生 + 等级 * 254
        end,
        速度 = function(等级, 转生)
            return math.random(1, 100) + 转生 * 100 + 等级 * 1
        end,
        抗性 = { 抗震慑 = 19 },
        技能 = {},
        施法几率 = 80,
        是否消失 = false,
    },


}

function 战斗:战斗初始化(玩家)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local r
    local 怪物属性
    for k, v in ipairs(_怪物) do
        怪物属性 = {}
        for i, s in pairs(v) do
            if type(s) == "function" then
                怪物属性[i] = s(等级, 转生)
            else
                怪物属性[i] = s
            end
        end
        r = 生成战斗怪物(怪物属性)
        r.等级 = 等级
        self:加入敌方(k, r)
    end
    local list = {}
    local t
    for i = 1, 5, 1 do
        t = _判官[math.random(#_判官)]
        if t then
            怪物属性 = {}
            for k, s in pairs(t) do
                if type(s) == "function" then
                    怪物属性[k] = s(等级, 转生)
                else
                    怪物属性[k] = s
                end
            end
            r = 生成战斗怪物(怪物属性)
            r.等级 = 等级
            self:加入敌方(i + 5, r)
        end
    end





end

function 战斗:战斗回合开始(dt)



end
local _掉落 = {
    { 几率 = 2, 名称 = '内丹精华', 数量 = 1, 广播 = true },
    { 几率 = 3, 名称 = '蟠桃', 数量 = 1, 广播 = true },
    { 几率 = 4, 名称 = '人参果王', 数量 = 1, 广播 = true },
    { 几率 = 2, 名称 = '神兵石', 数量 = 1, 广播 = true },
    { 几率 = 3, 名称 = '龙之骨', 数量 = 1, 广播 = true },
    { 几率 = 4, 名称 = '筋骨提气丸', 数量 = 1, 广播 = true },
    { 几率 = 5, 名称 = '神兵礼盒', 数量 = 1, 参数 = 1, 广播 = true },
    { 几率 = 90, 名称 = '补天神石', 数量 = 1, 广播 = true },
    { 几率 = 100, 名称 = '盘古精铁', 数量 = 1, 广播 = true },
    { 几率 = 200, 名称 = '天外飞石', 数量 = 1 },
    { 几率 = 300, 名称 = '千年寒铁', 数量 = 1 },
}

local function 掉落包(玩家)
    local 经验 = 5000
    玩家:添加任务经验(经验, "清明boss")
    if 玩家:取活动限制次数('清明boss') >= 5 then
        return
    end
    玩家:增加活动限制次数('清明boss')


    for i, v in ipairs(_掉落) do
        if math.random(1000) <= v.几率 then
            local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数 }
            if r then
                玩家:添加物品({ r })
                -- if v.广播 then
                --     玩家:发送系统(v.广播, 玩家.名称, r.nid, r.名称)
                -- end
                break
            end
        end
    end
end

function 战斗:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                掉落包(v.对象.接口)
            end
        end
    end
end

return 战斗
