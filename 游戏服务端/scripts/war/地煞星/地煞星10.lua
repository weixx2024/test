-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-07-18 00:33:41
-- @Last Modified time  : 2023-07-20 10:37:22

local 战斗 = {}

local _名称 = {
    '地狗星', '地英星', '地奇星', '地猛星', '地平星', '地会星', '地佐星', '地灵星', '地兽星', '地幽星',
    '地捷星', '地镇星', '地稽星', '地异星', '地退星', '地满星', '地遂星', '地理星', '地微星', '地全星',
    '地短星', '地角星', '地丑星', '地数星', '地阴星', '地刑星', '地壮星', '地嵇星', '地明星', '地乐星',
    '地慧星', '地俊星', '地空星', '地孤星', '地佑星', '地耗星', '地贼星', '地伏星', '地暴星', '地正星',
    '地强星', '地奴星', '地察星', '地隐星', '地巧星', '地飞星', '地默星', '地文星', '地然星', '地彗星',
}

local _怪物 = {
    强混 = {
        名称 = function()
            return _名称[math.random(#_名称)]
        end,
        外形 = function(等级, 转生)
            return 随机种族模型('男人', 转生)
        end,
        等级 = 120,
        气血 = 2600000,
        魔法 = 800000,
        攻击 = 17600,
        速度 = 860,
        抗性 = {
            抗混乱 = 112,
            抗封印 = 112,
            抗昏睡 = 112,
            抗中毒 = 52,
            抗风 = 42.5,
            抗火 = 42.5,
            抗水 = 42.5,
            抗雷 = 42.5,
            加强混乱 = 14,
            加强封印 = 14,
            加强昏睡 = 14,
            忽视抗混 = 7,
            忽视抗印 = 7,
            忽视抗睡 = 7,
            加强毒 = 50,
            忽视抗毒 = 32,
            抗震慑 = 13,
            物理吸收 = 62.5,
            躲闪率 = 32.5,
        },
        技能 = {
            { 名称 = "借刀杀人", 熟练度 = 15000 },
            { 名称 = "失心狂乱", 熟练度 = 15000 },
        },
        施法几率 = 100,
        是否消失 = false,
    },
    强毒 = {
        名称 = function()
            return _名称[math.random(#_名称)]
        end,
        外形 = function(等级, 转生)
            return 随机种族模型('女人', 转生)
        end,
        等级 = 120,
        气血 = 2600000,
        魔法 = 800000,
        攻击 = 17600,
        速度 = 760,
        抗性 = {
            抗混乱 = 112,
            抗封印 = 112,
            抗昏睡 = 112,
            抗中毒 = 52,
            抗风 = 42.5,
            抗火 = 42.5,
            抗水 = 42.5,
            抗雷 = 42.5,
            加强混乱 = 14,
            加强封印 = 14,
            加强昏睡 = 14,
            忽视抗混 = 7,
            忽视抗印 = 7,
            忽视抗睡 = 7,
            加强毒 = 50,
            忽视抗毒 = 32,
            抗震慑 = 13,
            物理吸收 = 62.5,
            躲闪率 = 32.5,
        },
        技能 = {
            { 名称 = "鹤顶红粉", 熟练度 = 15000 },
            { 名称 = "万毒攻心", 熟练度 = 15000 },
        },
        施法几率 = 100,
        是否消失 = false,
    },
    冰睡 = {
        名称 = function()
            return _名称[math.random(#_名称)]
        end,
        外形 = function(等级, 转生)
            return 随机种族模型('人族', 转生)
        end,
        等级 = 120,
        气血 = 2600000,
        魔法 = 800000,
        攻击 = 17600,
        速度 = 860,
        抗性 = {
            抗混乱 = 112,
            抗封印 = 112,
            抗昏睡 = 112,
            抗中毒 = 52,
            抗风 = 42.5,
            抗火 = 42.5,
            抗水 = 42.5,
            抗雷 = 42.5,
            加强混乱 = 14,
            加强封印 = 14,
            加强昏睡 = 14,
            忽视抗混 = 7,
            忽视抗印 = 7,
            忽视抗睡 = 7,
            加强毒 = 50,
            忽视抗毒 = 32,
            抗震慑 = 13,
            物理吸收 = 62.5,
            躲闪率 = 32.5,
        },
        技能 = {
            { 名称 = "迷魂醉", 熟练度 = 15000 },
            { 名称 = "百日眠", 熟练度 = 15000 },
            { 名称 = "作壁上观", 熟练度 = 15000 },
            { 名称 = "四面楚歌", 熟练度 = 15000 },
        },
        施法几率 = 100,
        是否消失 = false,
    },
    男魔 = {
        名称 = function()
            return _名称[math.random(#_名称)]
        end,
        外形 = function(等级, 转生)
            return 随机种族模型('男魔', 转生)
        end,
        等级 = 120,
        气血 = 1900000,
        魔法 = 500000,
        攻击 = 40600,
        速度 = 1400,
        抗性 = {
            抗混乱 = 80,
            抗封印 = 80,
            抗昏睡 = 80,
            抗风 = 47.5,
            抗火 = 47.5,
            抗水 = 47.5,
            抗雷 = 47.5,
            致命几率 = 5,
            狂暴几率 = 5,
            连击率 = 35,
            连击次数 = 4,
            附加震慑攻击 = 60,
            抗震慑 = 17,
            物理吸收 = 62.5,
        },
        技能 = {
            { 名称 = "魔神附身", 熟练度 = 15000 },
            { 名称 = "乾坤借速", 熟练度 = 15000 },
            { 名称 = "阎罗追命", 熟练度 = 15000 },
        },
        施法几率 = 50,
        是否消失 = false,
    },
    女魔 = {
        名称 = function()
            return _名称[math.random(#_名称)]
        end,
        外形 = function(等级, 转生)
            return 随机种族模型('女魔', 转生)
        end,
        等级 = 120,
        气血 = 1900000,
        魔法 = 500000,
        攻击 = 40600,
        速度 = 1300,
        抗性 = {
            抗混乱 = 80,
            抗封印 = 80,
            抗昏睡 = 80,
            抗风 = 47.5,
            抗火 = 47.5,
            抗水 = 47.5,
            抗雷 = 47.5,
            致命几率 = 5,
            狂暴几率 = 5,
            连击率 = 35,
            连击次数 = 4,
            附加震慑攻击 = 60,
            抗震慑 = 17,
            物理吸收 = 62.5,
        },
        技能 = {
            { 名称 = "魔神附身", 熟练度 = 15000 },
            { 名称 = "含情脉脉", 熟练度 = 15000 },
            { 名称 = "阎罗追命", 熟练度 = 15000 },
        },
        施法几率 = 50,
        是否消失 = false,
    },
    大力 = {
        名称 = function()
            return _名称[math.random(#_名称)]
        end,
        外形 = function(等级, 转生)
            return 随机种族模型('魔族', 转生)
        end,
        等级 = 120,
        气血 = 2600000,
        魔法 = 500000,
        攻击 = 83910,
        速度 = 520,
        抗性 = {
            抗混乱 = 90,
            抗封印 = 90,
            抗昏睡 = 90,
            抗风 = 47.5,
            抗火 = 47.5,
            抗水 = 47.5,
            抗雷 = 47.5,
            致命几率 = 22.5,
            狂暴几率 = 35,
            连击率 = 35,
            连击次数 = 4,
            反击率 = 35,
            反击次数 = 4,
            忽视防御几率 = 100,
            忽视防御程度 = 75,
            抗震慑 = 17,
            物理吸收 = 75,
        },
        是否消失 = false,
    },
    男仙 = {
        名称 = function()
            return _名称[math.random(#_名称)]
        end,
        外形 = function(等级, 转生)
            return 随机种族模型('男仙', 转生)
        end,
        等级 = 120,
        气血 = 1600000,
        魔法 = 3200000,
        攻击 = 13600,
        速度 = 1080,
        抗性 = {
            抗混乱 = 80,
            抗封印 = 80,
            抗昏睡 = 80,
            抗风 = 95,
            抗火 = 95,
            抗水 = 95,
            抗雷 = 95,
            加强雷 = 50,
            加强火 = 50,
            加强风 = 50,
            加强水 = 50,
            忽视抗雷 = 32,
            忽视抗火 = 32,
            忽视抗风 = 32,
            忽视抗水 = 32,
            雷系狂暴几率 = 26,
            火系狂暴几率 = 26,
            风系狂暴几率 = 26,
            水系狂暴几率 = 26,
            雷系狂暴程度 = 44,
            火系狂暴程度 = 44,
            风系狂暴程度 = 44,
            水系狂暴程度 = 44,
            抗震慑 = 13,
            躲闪率 = 62.5,
            物理吸收 = 47.5,
        },
        技能 = {
            { 名称 = "天诛地灭", 熟练度 = 15000 },
            { 名称 = "九龙冰封", 熟练度 = 15000 },
            { 名称 = "袖里乾坤", 熟练度 = 15000 },
        },
        施法几率 = 100,
        是否消失 = false,
    },
    女仙 = {
        名称 = function()
            return _名称[math.random(#_名称)]
        end,
        外形 = function(等级, 转生)
            return 随机种族模型('女仙', 转生)
        end,
        等级 = 120,
        气血 = 1600000,
        魔法 = 3200000,
        攻击 = 13600,
        速度 = 1080,
        抗性 = {
            抗混乱 = 80,
            抗封印 = 80,
            抗昏睡 = 80,
            抗风 = 95,
            抗火 = 95,
            抗水 = 95,
            抗雷 = 95,
            加强雷 = 50,
            加强火 = 50,
            加强风 = 50,
            加强水 = 50,
            忽视抗雷 = 32,
            忽视抗火 = 32,
            忽视抗风 = 32,
            忽视抗水 = 32,
            雷系狂暴几率 = 26,
            火系狂暴几率 = 26,
            风系狂暴几率 = 26,
            水系狂暴几率 = 26,
            雷系狂暴程度 = 44,
            火系狂暴程度 = 44,
            风系狂暴程度 = 44,
            水系狂暴程度 = 44,
            抗震慑 = 13,
            躲闪率 = 62.5,
            物理吸收 = 47.5,
        },
        技能 = {
            { 名称 = "天诛地灭", 熟练度 = 15000 },
            { 名称 = "九龙冰封", 熟练度 = 15000 },
            { 名称 = "九阴纯火", 熟练度 = 15000 },
        },
        施法几率 = 100,
        是否消失 = false,
    },
}

local _类型 = {
    '强混', '强毒', '冰睡', '男魔', '女魔', '大力', '男仙', '女仙'
}

function 战斗:战斗初始化(玩家, NPC)
    local 转生 = 1
    local 等级 = 120
    local list = {}
    for i = 1, 10 do
        local v = _怪物[_类型[math.random(#_类型)]]
        table.insert(list, v)
    end
    for i, v in ipairs(list) do
        local t = {}
        for k, s in pairs(v) do
            if type(s) == "function" then
                t[k] = s(等级, 转生)
            else
                t[k] = s
            end
        end
        if i == 1 then
            t.名称 = NPC.名称
        end
        local r = 生成战斗怪物(t)
        self:加入敌方(i, r)
    end
end

function 战斗:战斗回合开始(v)
end

function 战斗:战斗回合结束(v)
end

function 战斗:战斗开始(v)
end

function 战斗:战斗结束(s)
end

return 战斗