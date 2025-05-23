-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-07-18 00:33:41
-- @Last Modified time  : 2023-07-20 10:38:23

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
        等级 = 130,
        气血 = 2800000,
        魔法 = 880000,
        攻击 = 19200,
        速度 = 940,
        抗性 = {
            抗混乱 = 116,
            抗封印 = 116,
            抗昏睡 = 116,
            抗中毒 = 56,
            抗风 = 45,
            抗火 = 45,
            抗水 = 45,
            抗雷 = 45,
            加强混乱 = 16,
            加强封印 = 16,
            加强昏睡 = 16,
            忽视抗混 = 8,
            忽视抗印 = 8,
            忽视抗睡 = 8,
            加强毒 = 52,
            忽视抗毒 = 34,
            抗震慑 = 14,
            物理吸收 = 65,
            躲闪率 = 35,
        },
        技能 = {
            { 名称 = "借刀杀人", 熟练度 = 17500 },
            { 名称 = "失心狂乱", 熟练度 = 17500 },
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
        等级 = 130,
        气血 = 2800000,
        魔法 = 880000,
        攻击 = 19200,
        速度 = 840,
        抗性 = {
            抗混乱 = 116,
            抗封印 = 116,
            抗昏睡 = 116,
            抗中毒 = 56,
            抗风 = 45,
            抗火 = 45,
            抗水 = 45,
            抗雷 = 45,
            加强混乱 = 16,
            加强封印 = 16,
            加强昏睡 = 16,
            忽视抗混 = 8,
            忽视抗印 = 8,
            忽视抗睡 = 8,
            加强毒 = 52,
            忽视抗毒 = 34,
            抗震慑 = 14,
            物理吸收 = 65,
            躲闪率 = 35,
        },
        技能 = {
            { 名称 = "鹤顶红粉", 熟练度 = 17500 },
            { 名称 = "万毒攻心", 熟练度 = 17500 },
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
        等级 = 130,
        气血 = 2800000,
        魔法 = 880000,
        攻击 = 19200,
        速度 = 940,
        抗性 = {
            抗混乱 = 116,
            抗封印 = 116,
            抗昏睡 = 116,
            抗中毒 = 56,
            抗风 = 45,
            抗火 = 45,
            抗水 = 45,
            抗雷 = 45,
            加强混乱 = 16,
            加强封印 = 16,
            加强昏睡 = 16,
            忽视抗混 = 8,
            忽视抗印 = 8,
            忽视抗睡 = 8,
            加强毒 = 52,
            忽视抗毒 = 34,
            抗震慑 = 14,
            物理吸收 = 65,
            躲闪率 = 35,
        },
        技能 = {
            { 名称 = "迷魂醉", 熟练度 = 17500 },
            { 名称 = "百日眠", 熟练度 = 17500 },
            { 名称 = "作壁上观", 熟练度 = 17500 },
            { 名称 = "四面楚歌", 熟练度 = 17500 },
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
        等级 = 130,
        气血 = 2000000,
        魔法 = 520000,
        攻击 = 43600,
        速度 = 1750,
        抗性 = {
            抗混乱 = 84,
            抗封印 = 84,
            抗昏睡 = 84,
            抗风 = 50,
            抗火 = 50,
            抗水 = 50,
            抗雷 = 50,
            致命几率 = 5,
            狂暴几率 = 5,
            连击率 = 40,
            连击次数 = 5,
            附加震慑攻击 = 60,
            抗震慑 = 18,
            物理吸收 = 65,
        },
        技能 = {
            { 名称 = "魔神附身", 熟练度 = 17500 },
            { 名称 = "乾坤借速", 熟练度 = 17500 },
            { 名称 = "阎罗追命", 熟练度 = 17500 },
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
        等级 = 130,
        气血 = 2000000,
        魔法 = 520000,
        攻击 = 43600,
        速度 = 1650,
        抗性 = {
            抗混乱 = 84,
            抗封印 = 84,
            抗昏睡 = 84,
            抗风 = 50,
            抗火 = 50,
            抗水 = 50,
            抗雷 = 50,
            致命几率 = 5,
            狂暴几率 = 5,
            连击率 = 40,
            连击次数 = 5,
            附加震慑攻击 = 60,
            抗震慑 = 18,
            物理吸收 = 65,
        },
        技能 = {
            { 名称 = "魔神附身", 熟练度 = 17500 },
            { 名称 = "含情脉脉", 熟练度 = 17500 },
            { 名称 = "阎罗追命", 熟练度 = 17500 },
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
        等级 = 130,
        气血 = 2800000,
        魔法 = 520000,
        攻击 = 92040,
        速度 = 540,
        抗性 = {
            抗混乱 = 94,
            抗封印 = 94,
            抗昏睡 = 94,
            抗风 = 50,
            抗火 = 50,
            抗水 = 50,
            抗雷 = 50,
            致命几率 = 25,
            狂暴几率 = 40,
            连击率 = 40,
            连击次数 = 5,
            反击率 = 40,
            反击次数 = 5,
            忽视防御几率 = 100,
            忽视防御程度 = 80,
            抗震慑 = 18,
            物理吸收 = 80,
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
        等级 = 130,
        气血 = 1800000,
        魔法 = 3400000,
        攻击 = 14600,
        速度 = 1180,
        抗性 = {
            抗混乱 = 84,
            抗封印 = 84,
            抗昏睡 = 84,
            抗风 = 100,
            抗火 = 100,
            抗水 = 100,
            抗雷 = 100,
            加强雷 = 52,
            加强火 = 52,
            加强风 = 52,
            加强水 = 52,
            忽视抗雷 = 34,
            忽视抗火 = 34,
            忽视抗风 = 34,
            忽视抗水 = 34,
            雷系狂暴几率 = 28,
            火系狂暴几率 = 28,
            风系狂暴几率 = 28,
            水系狂暴几率 = 28,
            雷系狂暴程度 = 46,
            火系狂暴程度 = 46,
            风系狂暴程度 = 46,
            水系狂暴程度 = 46,
            抗震慑 = 14,
            躲闪率 = 65,
            物理吸收 = 50,
        },
        技能 = {
            { 名称 = "天诛地灭", 熟练度 = 17500 },
            { 名称 = "九龙冰封", 熟练度 = 17500 },
            { 名称 = "袖里乾坤", 熟练度 = 17500 },
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
        等级 = 130,
        气血 = 1800000,
        魔法 = 3400000,
        攻击 = 14600,
        速度 = 1180,
        抗性 = {
            抗混乱 = 84,
            抗封印 = 84,
            抗昏睡 = 84,
            抗风 = 100,
            抗火 = 100,
            抗水 = 100,
            抗雷 = 100,
            加强雷 = 52,
            加强火 = 52,
            加强风 = 52,
            加强水 = 52,
            忽视抗雷 = 34,
            忽视抗火 = 34,
            忽视抗风 = 34,
            忽视抗水 = 34,
            雷系狂暴几率 = 28,
            火系狂暴几率 = 28,
            风系狂暴几率 = 28,
            水系狂暴几率 = 28,
            雷系狂暴程度 = 46,
            火系狂暴程度 = 46,
            风系狂暴程度 = 46,
            水系狂暴程度 = 46,
            抗震慑 = 14,
            躲闪率 = 65,
            物理吸收 = 50,
        },
        技能 = {
            { 名称 = "天诛地灭", 熟练度 = 17500 },
            { 名称 = "九龙冰封", 熟练度 = 17500 },
            { 名称 = "九阴纯火", 熟练度 = 17500 },
        },
        施法几率 = 100,
        是否消失 = false,
    },
}

local _类型 = {
    '强混', '强毒', '冰睡', '男魔', '女魔', '大力', '男仙', '女仙'
}

function 战斗:战斗初始化(玩家, NPC)
    local 转生 = 2
    local 等级 = 130
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