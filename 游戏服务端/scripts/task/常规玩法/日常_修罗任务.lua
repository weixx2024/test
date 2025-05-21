local _地图 = { 1001, 1208, 1213, 1236, 1110, 1177, 1178, 1179, 1180, 1181, 1182, 1183, 1186, 1187, 1188, 1189,1190, 1191, 1192 }  -- 1194, , 五指山
-- local _地图 = {  1213 }  -- 1194, , 五指山
--长安, 东海渔村, 珊瑚海岛, 洛阳城, 大唐境内, 龙窟一层, 龙窟二层, 龙窟三层, 龙窟四层, 龙窟五层, 龙窟六层, 龙窟七层, 凤巢一层, 凤巢二层, 凤巢三层, 凤巢四层, 凤巢五层, 凤巢六层, 凤巢七层

local _怪信息 = {
    { name = '狂风修罗', 外形 = 2292 },
    { name = '摄魂修罗', 外形 = 2127 },
    { name = '烈焰修罗', 外形 = 2291 },
    { name = '金刚修罗', 外形 = 2098 },
    { name = '惧速修罗', 外形 = 2109 },
    { name = '嗜血修罗', 外形 = 2103 },
    { name = '怒雷修罗', 外形 = 2289 },
    { name = '惊涛修罗', 外形 = 2290 },
    { name = '虚无修罗', 外形 = 2096 }
}

local 任务 = {
    名称 = '日常_修罗任务',
    别名 = '修罗任务',
    类型 = '常规玩法'
}

function 任务:任务初始化()

end

function 任务:任务取详情(玩家)
    if self.NPC then
        return string.format('#Y任务目的:#r#W请速去#Y%s#W处消灭#G#u#[%s|%s|%s|$%s#]#u#W，阻止他为非作歹。(当前第#R%s#W次，剩余#R%d#W分钟)'
            , self.位置, self.MAP, self.x, self.y, self.怪名, 玩家.其它.修罗次数, (self.时间 - os.time())
            // 60)
    end
    return string.format('由于行动迟缓，#Y%s#W已经逃之夭夭了。\n', self.怪名)
end

function 任务:任务取消(玩家)
    玩家.其它.修罗次数 = 0
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            NPC.人数 = NPC.人数 - 1
            if NPC.人数 <= 0 then
                map:删除NPC(self.NPC)
            end
        end
    end
end

function 任务:任务上线(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if not NPC then
            self:删除()
        end
    end
end

function 任务:生成怪物(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    local xz = math.random(#_怪信息)
    self.怪名 = _怪信息[xz].name
    local X, Y = map:取随机坐标() --真坐标

    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}

    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.修罗次数 = v.其它.修罗次数 + 1
        if v.其它.修罗次数 > 7 then
            v.其它.修罗次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.外形 = _怪信息[xz].外形
    self.NPC =
        map:添加NPC {
            队伍 = self.队伍,
            人数 = #self.队伍,
            时长 = 1800,
            名称 = self.怪名,
            外形 = self.外形,
            脚本 = 'scripts/task/常规玩法/日常_修罗任务.lua',
            时间 = self.时间,
            任务类型 = "修罗",
            X = X,
            Y = Y,
            来源 = self
        }
    self.MAP = map.id
    self.x = X
    self.y = Y
    玩家:自动任务({
        类型 = "日常_修罗任务",
        nid = self.NPC,
        外形 = self.外形,
        id = self.MAP,
        x = self.x,
        y = self.y
    })
    if 玩家:月卡快传() then
        玩家:切换地图(self.MAP,self.x,self.y)
    end
    return true
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_修罗任务')
    if r then
        self:删除()
        self:掉落包(玩家)
    end
    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
end

local _广播 = '#C%s#c00FFFF在战胜修罗后意外发现了#G#m(%s)[%s]#m#n#c00FFFF乐呵呵的收进背包里#49'

function 任务:掉落包(玩家)
    local 银子 = 15000 * (1 + 玩家.其它.修罗次数 * 0.12)
    local 师贡 = 30000 * (1 + 玩家.其它.修罗次数 * 0.12)
    local 经验 = 607548 * (1 + 玩家.其它.修罗次数 * 0.072)
    local 法宝经验 = 360 + 玩家.其它.修罗次数 * 12

    local rw = 玩家:取任务('引导_修罗任务')
    if rw then
        rw:添加进度(玩家)
    end

    if 玩家.是否队长 then
        经验 = math.floor(经验 * 1.05)
        师贡 = math.floor(师贡 * 1.05)
        银子 = math.floor(银子 * 1.05)

        local t = 玩家:取物品是否存在('灵兽天行符')
        if not t then
            玩家:添加物品({ 生成物品 { 名称 = '灵兽天行符', 数量 = 1 } })
        end
    end

    玩家:添加任务经验(经验, "修罗")
    玩家:添加坐骑经验(1)
    玩家:添加法宝经验(法宝经验, "修罗")
    玩家:增加活动限制次数('修罗任务')
    if 玩家:取活动限制次数('修罗任务') > 200 then
        return
    end

    玩家:添加师贡(师贡, "修罗")
    玩家:添加银子(银子, "修罗")
 
 
    local 掉落包 = 取掉落包('日常', '修罗任务')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包, _广播)
    end
end

--===============================================
local 对话 = [[想要阻止我，也要看看自己有没有这份实力！
menu
1|看打！
2|点错
]]

function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "修罗" then
        local r = 玩家:取任务("日常_修罗任务")
        if r and r.NPC == NPC.nid then
            return 对话
        end
        return "我认识你么？"
    end
end

function 任务:NPC菜单(玩家, i)
    if i == '1' then
        local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_修罗任务.lua', self)
        玩家:自动任务_战斗结束(sf)
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.任务类型 == "修罗" then
        local r = 玩家:取任务("日常_修罗任务")
        if r and r.NPC == NPC.nid then
            local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_修罗任务.lua', NPC)
            玩家:自动任务_战斗结束(sf)
            return
        end
        return "我认识你么？"
    end
end

--===============================================
local _主怪 = {
    怒雷修罗 = {
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
    惊涛修罗 = {
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
        技能 = { { 名称 = "九龙冰封", 熟练度 = 18000 } },
        施法几率 = 50,
        是否消失 = false,
    },
    烈焰修罗 = {
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
        技能 = { { 名称 = "九阴纯火", 熟练度 = 18000 } },
        施法几率 = 50,
        是否消失 = false,
    },
    狂风修罗 = {
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
        抗性 = { 抗水 = 17, 抗雷 = 17, 抗火 = 17, 抗风 = 17, 抗鬼火 = -30, 抗震慑 = 31 },
        技能 = { { 名称 = "袖里乾坤", 熟练度 = 18000 } },
        施法几率 = 50,
        是否消失 = false,
    },
    狂暴修罗 = {
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
            return math.random(50, 100) + 转生 * 50 + 等级 * 3
        end,
        抗性 = { 抗水 = 17, 抗雷 = 17, 抗火 = 17, 抗风 = 17, 抗鬼火 = -30, 抗震慑 = 31 },
        施法几率 = 50,
        是否消失 = false,
    },
    摄魂修罗 = {
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
        技能 = { { 名称 = "阎罗追命", 熟练度 = 18000 } },
        抗性 = { 抗水 = 47, 抗雷 = 47, 抗火 = 47, 抗风 = 47, 抗震慑 = 31 },
        施法几率 = 50,
        是否消失 = false,
    },

    金刚修罗 = {
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
        技能 = { { 名称 = "阎罗追命", 熟练度 = 18000 } },
        抗性 = {
            忽视防御几率 = 100,
            忽视防御程度 = 120,
            抗震慑 = 31,
            抗水 = 16.9,
            抗雷 = 16.9,
            抗火 = 16.9,
            抗风 = 16.9,
            抗鬼火 = -30
        },
        施法几率 = 50,
        是否消失 = false,
    },

    惧速修罗 = {
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
            return math.random(50, 100) + 转生 * 50 + 等级 * 3
        end,
        技能 = { { 名称 = "阎罗追命", 熟练度 = 18000 }, { 名称 = "魔神附身", 熟练度 = 18000 },
            { 名称 = "含情脉脉", 熟练度 = 18000 }, { 名称 = "乾坤借速", 熟练度 = 18000 } },
        抗性 = { 抗震慑 = 31, 抗水 = 16.9, 抗雷 = 16.9, 抗火 = 16.9, 抗风 = 16.9, 抗鬼火 = 40 },
        施法几率 = 50,
        是否消失 = false,
    },

    嗜血修罗 = {
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
            return 15 + 等级 * 2
        end,
        技能 = { { 名称 = "阎罗追命", 熟练度 = 25000 }, { 名称 = "魔神附身", 熟练度 = 25000 } },
        抗性 = { 抗震慑 = 31, 抗水 = 39.7, 抗雷 = 39.7, 抗火 = 39.7, 抗风 = 39.7, 抗鬼火 = 60 },
        施法几率 = 50,
        是否消失 = false,
    },
    虚无修罗 = {
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
            return math.random(50, 100) + 转生 * 50 + 等级 * 3
        end,
        技能 = { { 名称 = "阎罗追命", 熟练度 = 10000 }, { 名称 = "魔音摄心", 熟练度 = 18000 } },
        抗性 = { 抗震慑 = 31, 抗水 = 72, 抗雷 = 72, 抗火 = 72, 抗风 = 72, 抗鬼火 = 80 },
        施法几率 = 50,
        是否消失 = false,
    },

}

local _小怪 = {
    {
        名称 = "喽啰",
        外形 = 2060,
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
        抗性 = {
            抗水 = 10,
            抗雷 = 10,
            抗火 = 10,
            抗风 = 10,
            抗鬼火 = -10,
            抗毒伤害 = -1000,
            抗混乱 = 0,
            抗封印 = 90,
            抗中毒 = 90,
            抗昏睡 = 0
        },
        技能 = { { 名称 = "借刀杀人", 熟练度 = 25000 } },
        施法几率 = 50,
        是否消失 = false,
    }, --猴精
    {
        名称 = "喽啰",
        外形 = 2099,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = 10,
            抗雷 = 10,
            抗火 = 10,
            抗风 = 10,
            抗鬼火 = -10,
            抗毒伤害 = -
                1000,
            抗混乱 = 0,
            抗封印 = 90,
            抗中毒 = 90,
            抗昏睡 = 0
        },
        技能 = { { 名称 = "迷魂醉", 熟练度 = 25000 } },
        施法几率 = 50,
        是否消失 = false,
    }, --冰雪魔
    {
        名称 = "喽啰",
        外形 = 2106,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = 10,
            抗雷 = 10,
            抗火 = 10,
            抗风 = 10,
            抗鬼火 = -10,
            抗毒伤害 = -
                1000,
            抗混乱 = 0,
            抗封印 = 90,
            抗中毒 = 90,
            抗昏睡 = 0
        },
        技能 = { { 名称 = "万毒攻心", 熟练度 = 10000 } },
        施法几率 = 50,
        是否消失 = false,
    }, --狮蝎
    {
        名称 = "喽啰",
        外形 = 2101,
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
            return -598 - 等级
        end,
        抗性 = {
            抗震慑 = 19,
            抗水 = 10,
            抗雷 = 10,
            抗火 = 10,
            抗风 = 10,
            抗鬼火 = -10,
            抗毒伤害 = -
                1000,
            抗混乱 = 0,
            抗封印 = 90,
            抗中毒 = 90,
            抗昏睡 = 0,
            狂暴几率 = 100,
            命中率 = 100,
            忽视防御程度 = 120,
            忽视防御几率 = 100
        },
        技能 = { { 名称 = "魔神护体", 熟练度 = 25000 } },
        施法几率 = 50,
        是否消失 = false,
    }, --泥石怪
    {
        名称 = "喽啰",
        外形 = 2100,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = 50,
            抗雷 = 50,
            抗火 = 50,
            抗风 = 50,
            抗鬼火 = -50,
            抗毒伤害 = -
                6000,
            抗混乱 = 0,
            抗封印 = 150,
            抗中毒 = 150,
            抗昏睡 = 0
        },
        技能 = {},
        施法几率 = 50,
        是否消失 = false,
    }, --水灵仙

    {
        名称 = "喽啰",
        外形 = 3828,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = 50,
            抗雷 = 50,
            抗火 = 50,
            抗风 = 50,
            抗鬼火 = -50,
            抗毒伤害 = -
                6000
        },
        技能 = { { 名称 = "九阴纯火", 熟练度 = 10000 }, { 名称 = "九龙冰封", 熟练度 = 15000 } },
        施法几率 = 50,
        是否消失 = false,
    }, --碧水精魄

    {
        名称 = "喽啰",
        外形 = 2129,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = -50,
            抗雷 = -50,
            抗火 = -50,
            抗风 = -50,
            抗鬼火 = 40,
            抗毒伤害 = -
                6000
        },
        技能 = { { 名称 = "九阴纯火", 熟练度 = 10000 }, { 名称 = "烈火骄阳", 熟练度 = 15000 } },
        施法几率 = 80,
        是否消失 = false,
    }, --狐小妖

    {
        名称 = "喽啰",
        外形 = 2129,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = -50,
            抗雷 = -50,
            抗火 = -50,
            抗风 = -50,
            抗鬼火 = 40,
            抗毒伤害 = -
                6000
        },
        技能 = { { 名称 = "九阴纯火", 熟练度 = 10000 }, { 名称 = "烈火骄阳", 熟练度 = 15000 } },
        施法几率 = 80,
        是否消失 = false,
    }, --吉祥果

    {
        名称 = "喽啰",
        外形 = 2125,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = -50,
            抗雷 = -50,
            抗火 = -50,
            抗风 = -50,
            抗鬼火 = 40,
            抗毒伤害 = -
                6000
        },
        技能 = { { 名称 = "风雷涌动", 熟练度 = 10000 }, { 名称 = "袖里乾坤", 熟练度 = 15000 } },
        施法几率 = 80,
        是否消失 = false,
    }, --铁扇公主
    {
        名称 = "喽啰",
        外形 = 2128,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = -50,
            抗雷 = -50,
            抗火 = -50,
            抗风 = -50,
            抗鬼火 = 40,
            抗毒伤害 = -
                6000
        },
        技能 = { { 名称 = "九阴纯火", 熟练度 = 10000 }, { 名称 = "九龙冰封", 熟练度 = 15000 } },
        施法几率 = 80,
        是否消失 = false,
    }, --天龙女
    {
        名称 = "喽啰",
        外形 = 2107,
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
        抗性 = {
            抗震慑 = 19,
            抗水 = -50,
            抗雷 = -50,
            抗火 = -50,
            抗风 = -50,
            抗鬼火 = 40,
            抗毒伤害 = -
                6000
        },
        技能 = { { 名称 = "魔音摄心", 熟练度 = 10000 }, { 名称 = "楚楚可怜", 熟练度 = 15000 } },
        施法几率 = 80,
        是否消失 = false,
    }, --罗刹鬼姬

    {
        名称 = "喽啰",
        外形 = 2107,
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
    }, --开山怪









}


local _数量表 = { 5, 6, 7, 7, 7, 7, 7, 7, 8, 9 }
function 任务:战斗初始化(玩家, NPC)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local t = _主怪[NPC.名称]
    local list = {}
    if t then
        t.名称 = NPC.名称
        t.外形 = NPC.外形
        table.insert(list, t)
    end
    self.NPC_nid = NPC.nid

    数量 = _数量表[玩家.其它.修罗次数]
    if not 数量 then
        数量 = 5
    end



    for i = 1, 数量 do
        t = _小怪[math.random(#_小怪)]
        if t then
            table.insert(list, t)
        end
    end

    for k, v in ipairs(list) do
        for i, s in pairs(v) do
            if type(s) == "function" then
                v[i] = s(等级, 转生)
            end
        end
        local r = 生成战斗怪物(v)
        r.等级 = 等级


        self:加入敌方(k, r)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("日常_修罗任务")
                if r and r.NPC == self.NPC_nid then
                    r:完成(v.对象.接口)
                end
            end
        end
    end
end

return 任务
