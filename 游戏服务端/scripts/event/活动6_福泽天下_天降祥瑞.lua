local 事件 = {
    名称 = '天降祥瑞',
    类型 = '活动',
    是否打开 = true,
    是否可接任务 = true,
}

function 事件:事件初始化()
    -- 开启时间：周四早8点到晚10点
    if os.date('%w', os.time()) == '6' then
        print('星期六，开启天降祥瑞活动')
        local year = tonumber(os.date('%Y', os.time()))
        local month = tonumber(os.date('%m', os.time()))
        local day = tonumber(os.date('%d', os.time()))
        self.开始时间 = os.time { year = year, month = month, day = day, hour = 08, min = 00, sec = 00 }
        self.结束时间 = os.time { year = year, month = month, day = day, hour = 22, min = 00, sec = 00 }
        self.是否结束 = false
    end
end

local _地图 = { 1208, 1193, 1194, 1110, 1091, 1070, 1092, 1173, }

local _主怪信息 = {
    { 名称 = '瑞云', 模型 = 2150, 数量 = 20 },
    { 名称 = '瑞雨', 模型 = 2150, 数量 = 20 },
    { 名称 = '瑞霞', 模型 = 2150, 数量 = 20 },
    { 名称 = '日月光', 模型 = 2130, 数量 = 10 },
    { 名称 = '钟律调', 模型 = 2129, 数量 = 10 },
    { 名称 = '斗极明', 模型 = 2126, 数量 = 10 },
    { 名称 = '越裳来', 模型 = 3121, 数量 = 10 },
    { 名称 = '孝道至', 模型 = 47, 数量 = 10 },
    { 名称 = '四夷化', 模型 = 46, 数量 = 10 },
    { 名称 = '甘露降', 模型 = 2128, 数量 = 10 },
}

function 事件:清除所有怪物()
    for ii, vv in ipairs(_地图) do
        local map = self:取地图(vv)
        for i = 1, #_主怪信息 do
            for k, v in map:遍历NPC() do
                if v.名称 == _主怪信息[i].名称 then
                    v:删除()
                end
            end
        end
    end
end

function 事件:更新()
    if self.是否结束 then
        return
    end
    local 地图组 = {}
    self.时间 = os.time() + 30 * 60
    for ii, vv in ipairs(_地图) do
        local map = self:取地图(vv)
        table.insert(地图组, map.名称)
        for i = 1, #_主怪信息 do
            for k, v in map:遍历NPC() do
                if v.名称 == _主怪信息[i].名称 and not v.战斗中 then
                    v:删除()
                end
            end

            local 刷新数量 = _主怪信息[i].数量
            for _ = 1, 刷新数量 do
                local 方向 = math.random(1, 4)
                local X, Y = map:取随机坐标()
                local NPC = map:添加NPC {
                    名称 = _主怪信息[i].名称,
                    外形 = _主怪信息[i].模型,
                    称谓 = '天降祥瑞',
                    方向 = 方向,
                    脚本 = 'scripts/event/活动6_福泽天下_天降祥瑞.lua',
                    时间 = self.时间,
                    X = X,
                    Y = Y,
                    来源 = self
                }
            end
        end
    end

    self:发送系统('#G承平天下，为了庆祝这场盛世华诞，天上的祥瑞之神纷纷下落凡间，他们各自带着礼物无数，在#Y%s#G等待各路英雄前去挑战。', table.concat(地图组, '、'))
    return 1800
end

function 事件:事件开始()
    self:更新()
    self:定时(1800, self.更新)
    print('天降祥瑞活动开始')
end

function 事件:事件结束()
    self.是否结束 = true
    self:清除所有怪物()
    print('天降祥瑞活动结束')
end

--=======================================================
local 对话 = [[
没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]
function 事件:NPC对话(玩家, NPC)
    return 对话
end

function 事件:NPC菜单(玩家, i, NPC)
    if NPC and NPC:是否战斗中() then
        return "我正在战斗中"
    end
    if i == '1' then
        if not NPC:是否战斗中() then
            if i == '1' then
                NPC:进入战斗(true)
                local r = 玩家:进入战斗('scripts/event/活动6_福泽天下_天降祥瑞.lua', NPC)
                NPC:进入战斗(false)
                if r then
                    self:完成(玩家, NPC)
                    NPC:删除()
                end
            end
        else
            return "我正在战斗中"
        end
    end
end

local _小怪物属性 = {
    {
        名称 = "瑞云",
        外形 = 2150,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 50 + 等级 * 6
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 20,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                雷系狂暴几率 = 10,
                风系狂暴几率 = 10,
                水系狂暴几率 = 10,
                火系狂暴几率 = 10,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "天诛地灭", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },
                { 名称 = "袖里乾坤", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },
                { 名称 = "九龙冰封", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },
                { 名称 = "九阴纯火", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },
            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },
    {
        名称 = "瑞雨",
        外形 = 2150,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 43 + 等级 * 3
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 20,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "失心狂乱", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },

            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },

    {
        名称 = "瑞霞",
        外形 = 2150,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 88 + 等级 * 5
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 20,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "迷魂醉", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },

            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },
    {
        名称 = "日月光",
        外形 = 2130,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return -800
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 40,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = {},
        施法几率 = 60,
        是否消失 = false,
    },
    {
        名称 = "钟律调",
        外形 = 2129,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 44 + 等级 * 3
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 20,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "九龙冰封", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },

            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },

    {
        名称 = "斗极明",
        外形 = 2126,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 74 + 等级 * 5
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 10,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "断肠烈散", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },

            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },

    {
        名称 = "越裳来",
        外形 = 3121,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 86 + 等级 * 4
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 10,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "九阴纯火", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },
            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },

    {
        名称 = "孝道至",
        外形 = 47,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 65 + 等级 * 3
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 20,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "九阴纯火", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },
            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },

    {
        名称 = "四夷化",
        外形 = 46,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 21 + 等级 * 3
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 21,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "袖里乾坤", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },
            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },

    {
        名称 = "甘露降",
        外形 = 2128,
        气血 = function(等级, 转生)
            return 251454 + 等级 * 3200
        end,
        魔法 = function(等级, 转生)
            return 26000 + 等级 * 35
        end,
        攻击 = function(等级, 转生)
            return 10 + 等级 * 190
        end,
        速度 = function(等级, 转生)
            return 20 + 等级 * 3
        end,
        抗性 = function(等级, 转生)
            return {
                物理吸收 = 21,
                抗震慑 = 30,
                抗水 = -180,
                抗雷 = -180,
                抗火 = -180,
                抗风 = -180,
                抗鬼火 = -180,
                抗毒伤害 = -1000,
                抗混乱 = 30,
                抗封印 = 30,
                抗中毒 = 30,
                加强雷 = 30,
                加强风 = 30,
                加强火 = 30,
                加强水 = 30,
            }
        end,

        技能 = function(等级, 转生)
            return {
                { 名称 = "百日眠", 熟练度 = 5000 + 转生 * 5000 + 等级 * 40 },
            }
        end,
        施法几率 = 60,
        是否消失 = false,
    },


}

function 事件:战斗初始化(玩家, NPC)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性

    local 数量 = math.random(7, 10)

    for n = 1, 数量 do
        怪物属性 = {}
        local r = _小怪物属性[math.random(#_小怪物属性)]

        for k, v in pairs(r) do
            if type(v) == "function" then
                怪物属性[k] = v(等级, 转生)
            else
                怪物属性[k] = v
            end
        end
        if n == 1 then
            怪物属性.名称 = NPC.名称
            怪物属性.外形 = NPC.外形
        end
        self:加入敌方(n, 生成战斗怪物(怪物属性))
    end
end

function 事件:战斗回合开始(dt)
end

function 事件:战斗结束(x, y)
end

function 事件:完成(玩家, NPC)
    for k, v in 玩家:遍历队伍() do
        self:掉落包(v, NPC)
    end
end

local _广播 = {
    [1] = "祥瑞小神潇洒的当着#R%s#C的面掏出了自己的#G#m(%s)[%s]#m#C，拍了怕身上的尘土，说道：“想要你就说嘛，说了我就给你嘛，别把我的新衣服弄脏了#47",
    [2] = "百卉含英百花开，#R%s#C好运连连来，得了个#G#m(%s)[%s]#m#86",
    [3] = "太白金星冲着#R%s#C喊道：“承平天下，天降祥瑞，#G#m(%s)[%s]#m#C掉头上的感觉爽不爽#86",
}

function 事件:掉落包(玩家, NPC)
    if 玩家:取活动限制次数('天降祥瑞') >= 60 then
        return
    end
    玩家:增加活动限制次数('天降祥瑞')

    local 经验 = 350000
    玩家:添加任务经验(经验)
    玩家:添加法宝经验(500)

    local 掉落包 = 取掉落包('活动','天降祥瑞')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包, _广播[math.random(1, 3)])
    end
end

return 事件
