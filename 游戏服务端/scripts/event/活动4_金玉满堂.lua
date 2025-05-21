local 事件 = {
    名称 = '金玉满堂',
    类型 = '活动',
    是否打开 = true,
    是否可接任务 = true,
}

function 事件:事件初始化()
    -- 开启时间：周四早8点到晚10点
    if os.date('%w', os.time()) == '2' then
        print('星期二，开启金玉满堂活动')
        local year = tonumber(os.date('%Y', os.time()))
        local month = tonumber(os.date('%m', os.time()))
        local day = tonumber(os.date('%d', os.time()))
        self.开始时间 = os.time { year = year, month = month, day = day, hour = 08, min = 00, sec = 00 }
        self.结束时间 = os.time { year = year, month = month, day = day, hour = 22, min = 00, sec = 00 }
        self.是否结束 = false
    end
end

local _地图 = { 1194, 1174, 1092, 1070 } -- 五指山, 北俱芦洲, 傲来国, 长寿村

local _主怪信息 = {
    [1] = { 名称 = '晴娘', 模型 = 2107, 数量 = 20 },
    [2] = { 名称 = '晴娘', 模型 = 2113, 数量 = 20 },
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
                    称谓 = '金玉满堂',
                    方向 = 方向,
                    脚本 = 'scripts/event/活动4_金玉满堂.lua',
                    时间 = self.时间,
                    X = X,
                    Y = Y,
                    来源 = self
                }
            end
        end
    end

    self:发送系统('#G晴娘出现在#Y%s，#G想知道一会是晴天还是阴天的朋友不如赶紧去找晴娘请教请教#132。', table.concat(地图组, '、'))
    return 1800
end

function 事件:事件开始()
    self:更新()
    self:定时(1800, self.更新)
    print('金玉满堂活动开始')
end

function 事件:事件结束()
    self.是否结束 = true
    self:清除所有怪物()
    print('金玉满堂活动结束')
end

--=======================================================
local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]
function 事件:NPC对话(玩家, i)
    return 对话
end

function 事件:NPC菜单(玩家, i)
    if i == '1' then
        if not self:是否战斗中() then
            self:进入战斗(true)
            local r = 玩家:进入战斗('scripts/event/活动4_金玉满堂.lua', self)
            self:进入战斗(false)
            if r then
                self:删除()
                self:完成(玩家)
            end
        else
            return "我正在战斗中"
        end
    end
end

--===============================================

local _外形 = { 0, 2096, 2096, 2107, 2107 }
local _小怪信息 = {
    { 名称 = "龙", 外形 = 2070, 技能 = { "失心狂乱" } },
    { 名称 = "凤", 外形 = 2071, 技能 = { "三昧真火", "九阴纯火" } },
    { 名称 = "呈", 外形 = 2021, 技能 = {} },
    { 名称 = "吉", 外形 = 2039, 技能 = { "龙啸九天", "九龙冰封" } },
    { 名称 = "祥", 外形 = 2023, 技能 = {} },
    { 名称 = "如", 外形 = 2036, 技能 = { "雷神怒击", "天诛地灭" } },
    { 名称 = "意", 外形 = 2030, 技能 = { "太乙生风", "袖里乾坤" } },
}

function 事件:战斗初始化(玩家, NPC)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    for i = 1, 5 do
        local 怪物属性 = {
            外形 = i == 1 and NPC.外形 or _外形[i],
            名称 = '晴娘',
            等级 = 等级,
            气血 = 100000 + 等级 * 4000,
            魔法 = 26000 + 等级 * 35,
            攻击 = 1 + 等级 * 20,
            速度 = 120 + 等级 * 3,
            抗性 = {
                抗震慑 = 5,
                抗混乱 = 30,
                抗封印 = 30,
                抗昏睡 = 30,
                抗水 = -32,
                抗雷 = -32,
                抗火 = -32,
                抗风 = -32,
                加强混乱 = 10,
                加强雷 = 15,
                加强风 = 15,
                加强火 = 15,
                加强水 = 15,
            },
            技能 = {
                { 名称 = "失心狂乱", 熟练度 = 10000 },
                { 名称 = "九龙冰封", 熟练度 = 10000 },
                { 名称 = "袖里乾坤", 熟练度 = 10000 },
                { 名称 = "阎罗追命", 熟练度 = 10000 },
            },
            施法几率 = 100,
            是否消失 = false,
            --内丹 = { '乘风破浪' }
        }
        self:加入敌方(i, 生成战斗怪物(怪物属性))
    end

    for i = 6, 10 do
        local 怪 = _小怪信息[math.random(#_小怪信息)]
        local 怪物属性 = {
            外形 = 怪.外形,
            名称 = 怪.名称,
            等级 = 等级,
            气血 = 100000 + 等级 * 4000,
            魔法 = 26000 + 等级 * 35,
            攻击 = 1 + 等级 * 20,
            速度 = 120 + 等级 * 3,
            抗性 = {
                抗震慑 = 5,
                抗混乱 = 30,
                抗封印 = 30,
                抗昏睡 = 30,
                抗水 = -32,
                抗雷 = -32,
                抗火 = -32,
                抗风 = -32,
                加强混乱 = 10,
                加强雷 = 15,
                加强风 = 15,
                加强火 = 15,
                加强水 = 15,
            },
            技能 = {
                { 名称 = "太乙生风", 熟练度 = 10000 },
                { 名称 = "含情脉脉", 熟练度 = 10000 },
                { 名称 = "龙啸九天", 熟练度 = 10000 },
                { 名称 = "三味真火", 熟练度 = 10000 },
            },
            施法几率 = 50,
            是否消失 = false,

        }

        for k, v in ipairs(怪.技能) do
            table.insert(怪物属性.技能, v)
        end


        self:加入敌方(i, 生成战斗怪物(怪物属性))
    end
end

function 事件:战斗回合开始(dt)
end

function 事件:战斗结束(x, y)
end

--===============================================
function 事件:完成(玩家)
    for _, v in 玩家:遍历队伍() do
        self:掉落包(v)
    end
end

local _广播 = '#R%s#c00FFFF正收缴晴娘留下的宝物时,隐隐看到有一线金光,走近一看,原来是个宝盒。打开一看,盒子里装的竟是#G#m(%s)[%s]#m#n#c00FFFF一个，发财啦!#93'

function 事件:掉落包(玩家)
    if 玩家:取活动限制次数('金玉满堂') >= 60 then
        return
    end

    玩家:增加活动限制次数('金玉满堂')

    local 经验 = 661024
    玩家:添加经验(经验)
    玩家:添加参战召唤兽经验(经验 * 1.5)


    local 掉落包 = 取掉落包('活动', '金玉满堂')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包, _广播)
 
    end
end

return 事件
