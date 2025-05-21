local 任务 = {
    名称 = '日常_天庭任务',
    别名 = '天庭任务',
    类型 = '常规玩法'
}

function 任务:任务初始化()

end

--#G#u#[1199|180|100|$万年熊王#]#u
--#G#u#[1199|10|100|$三头妖王#]#u
--#G#u#[1199|180|100|$蓝色妖王#]#u
--#G#u#[1199|150|150|$黑山妖王#]#u

function 任务:任务取详情(玩家)
    return string.format(
        '#Y任务目的:#r#W阻止御马监四个妖魔吸取天地精华。当前天庭任务是由#Y%s#W领导的挑战#r#G#u#[1199|180|100|$万年熊王#]#u#Y%s#W/1次#r#G#u#[1199|10|100|$三头妖王#]#u#Y%s#W/1次#r#G#u#[1199|180|100|$蓝色妖王#]#u#Y%s#W/1次#r#G#u#[1199|150|150|$黑山妖王#]#u#Y%s#W/1次#r#W(剩余#R%d#W分钟)'
        , self.队长, self.万年熊王, self.三头妖王, self.蓝色妖王, self.黑山妖王,
        (self.时间 - os.time()) // 60)
end

function 任务:任务取消(玩家)
    玩家.其它.天庭次数 = 0
end

function 任务:任务更新(sec)
    if not self.时间 then
        self.时间 = os.time() + 30 * 60
    end
    if self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:添加任务(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    if 玩家:取队伍人数() < 3 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    local t = {}
    for _, v in 玩家:遍历队伍() do
        if v:判断等级是否低于(69) then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于70级,无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        --if not v:剧情称谓是否存在(8) then
        --    table.insert(t, v.名称)
        --end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '没有完成八称，无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_天庭任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end

    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.天庭次数 = v.其它.天庭次数 + 1
        if v.其它.天庭次数 > 10 then
            v.其它.天庭次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.队长 = 玩家.名称
    self.万年熊王 = 0
    self.三头妖王 = 0
    self.蓝色妖王 = 0
    self.黑山妖王 = 0
    self.自动数据 = {
        { "万年熊王", 0 },
        { "三头妖王", 0 },
        { "蓝色妖王", 0 },
        { "黑山妖王", 0 },
    } --自动用
    --设置熊王
    self.自动 = { 名称 = "万年熊王" }
    玩家:自动任务({ 类型 = "日常_天庭任务", id = 1199, x = 180, y = 10 })
    if 玩家:月卡快传() then
        玩家:切换地图(1199, 180, 10)
    end
    return true
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_天庭任务')
    if r then
        self:删除()
    end
end

local _广播 = '#C%s#c00FFFF在天庭任务中表现出色，得到玉帝赏赐#G#m(%s)[%s]#m#n#c00FFFF一个#93'

function 任务:掉落包(玩家, 次数)
    if 玩家:判断等级是否高于(120) then
        return
    end

    local 师贡 = math.floor(10000 * (1 + 次数 * 0.22) * 0.75)
    local 银子 = math.floor(5000 * (1 + 次数 * 0.22) * 0.75)
    local 经验 = math.floor(168452 * (1 + 次数 * 0.13))
    local 法宝经验 = 180 + 次数 * 24

    local r = 玩家:取任务('引导_天庭任务')
    if r then
        r:添加进度(玩家)
    end

    if 玩家.是否队长 then
        经验 = math.floor(经验 * 1.05)
        银子 = math.floor(银子 * 1.05)
        师贡 = math.floor(师贡 * 1.05)
    end

    玩家:添加任务经验(经验, "天庭")
    玩家:添加法宝经验(法宝经验, "天庭")
    玩家:添加坐骑经验(1)

    if 玩家:取活动限制次数('天庭任务') > 100 then
        return
    end

    玩家:添加师贡(师贡, "天庭")
    玩家:添加银子(银子, "天庭")

    if 玩家:判断等级是否高于(110) then
        玩家:常规提示('#Y你的等级大于110级，无法获取经验')
        return
    end

    local 掉落包 = 取掉落包('日常', '天庭任务')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包, _广播)
    end
end

function 任务:打败怪物(玩家, 名称)
    --设置下个目标
    self[名称] = 1
    if self.万年熊王 == 1 and self.三头妖王 == 1 and self.蓝色妖王 == 1 and self.黑山妖王 == 1 then
        玩家:增加活动限制次数('天庭任务')
        self:完成(玩家)
        --设置领取
    end

    self:掉落包(玩家, 玩家.其它.天庭次数)
end

--===============================================

local _台词 = '没想到，居然还是让你们找到了本王\nmenu\n1|妖孽，看剑#126\n2|我认错妖了。#76'
function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '万年熊王' and NPC.台词 then
        if self.万年熊王 == 0 then
            NPC.台词 = _台词
        end
    elseif NPC.名称 == '三头妖王' and NPC.台词 then
        if self.三头妖王 == 0 then
            NPC.台词 = _台词
        end
    elseif NPC.名称 == '蓝色妖王' and NPC.台词 then
        if self.蓝色妖王 == 0 then
            NPC.台词 = _台词
        end
    elseif NPC.名称 == '黑山妖王' and NPC.台词 then
        if self.黑山妖王 == 0 then
            NPC.台词 = _台词
        end
    end
end

local _npc = {
    万年熊王 = 1,
    三头妖王 = 2,
    蓝色妖王 = 3,
    黑山妖王 = 4,
}
local _自动排序 = {
    万年熊王 = { 类型 = "日常_天庭任务", id = 1199, x = 180, y = 10 },
    三头妖王 = { 类型 = "日常_天庭任务", id = 1199, x = 10, y = 100 },
    蓝色妖王 = { 类型 = "日常_天庭任务", id = 1199, x = 180, y = 100 },
    黑山妖王 = { 类型 = "日常_天庭任务", id = 1199, x = 150, y = 150 },

}

function 任务:任务NPC菜单(玩家, NPC, i)
    if _npc[NPC.名称] then
        if i == '1' then
            local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_天庭任务.lua', NPC)
            if sf then
                self.自动数据[_npc[NPC.名称]][2] = 1
                for _, v in ipairs(self.自动数据) do
                    if v[2] == 0 then
                        self.自动 = { 名称 = v[1] }
                        玩家:自动任务(_自动排序[v[1]])
                        return
                    end
                end
                玩家:自动任务_战斗结束(sf)
            else
                玩家:自动任务_战斗结束(sf)
            end
        end
    end
end

--===============================================


local _小怪物属性 = {

    {
        名称 = "喽啰",
        外形 = 2023,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "魔音摄心", "追神摄魄", "夺命勾魂" }
    }, --雷鸟人
    {
        名称 = "喽啰",
        外形 = 2008,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "雷神怒击", "日照光华", "雷霆霹雳" }
    }, --寒钢怪
    {
        名称 = "喽啰",
        外形 = 2019,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "三味真火", "地狱烈火", "天雷怒火" }
    }, --精怪

    {
        名称 = "喽啰",
        外形 = 2021,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "断肠烈散", "蛇蝎美人", "追魂迷香" }
    }, --鼠怪
    {
        名称 = "喽啰",
        外形 = 2038,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "魔音摄心", "魔之飞步", "急速之魔" }
    }, --白虎
    {
        名称 = "喽啰",
        外形 = 2024,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 2
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "龙啸九天", "龙卷雨击", "龙腾水溅" }
    }, --小龙女
    {
        名称 = "喽啰",
        外形 = 2068,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "太乙生风", "飞砂走石", "乘风破浪" }
    }, --神灵
    {
        名称 = "喽啰",
        外形 = 2060,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "情真意切", "谗言相加", "反间之计" }
    }, --猴精
    {
        名称 = "喽啰",
        外形 = 2041,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "雷神怒击", "雷霆霹雳", "日照光华" }
    }, --古代瑞兽
    {
        名称 = "喽啰",
        外形 = 2014,
        气血 = function(等级, 转生)
            return 32587 + 转生 * 50000 + 等级 * 2500
        end,
        魔法 = function(等级, 转生)
            return 1700
        end,
        攻击 = function(等级, 转生)
            return 150 + 等级 * 30
        end,
        速度 = function(等级, 转生)
            return 1 + 等级 * 1
        end,
        抗性 = { 抗水 = -79, 抗雷 = -79, 抗火 = -79, 抗风 = -79, 抗震慑 = 10 },
        技能 = { "三味真火", "地狱烈火", "天雷怒火" }
    }, --鸟嘴兽

}



local function 取万年熊王信息(玩家, 等级, 转生)
    local 战斗单位 = {}
    战斗单位[1] = {
        名称 = "万年熊王",
        外形 = 2006,
        等级 = 等级,
        气血 = 125845 + 等级 * 1000,
        魔法 = 47000,
        攻击 = 150 + 等级 * 30,
        速度 = 1 + 等级 * 1,
        抗性 = {
            抗水 = -72,
            抗雷 = -72,
            抗火 = -72,
            抗风 = -72,
            抗震慑 = 17
        },
        技能 = { "失心狂乱" },
        施法几率 = 50,
        是否消失 = false,
    }
    for n = 1, 4 do
        local r = _小怪物属性[math.random(#_小怪物属性)]
        for k, v in pairs(r) do
            if type(v) == "function" then
                r[k] = v(等级, 转生)
            end
        end
        r.施法几率 = 50
        r.是否消失 = false
        table.insert(战斗单位, r)
    end
    return 战斗单位
end

local function 取三头妖王信息(玩家, 等级, 转生)
    local 战斗单位 = {}
    战斗单位[1] = {
        名称 = "三头妖王",
        外形 = 2074,
        等级 = 等级,
        气血 = 32587 + 转生 * 50000 + 等级 * 5000,
        魔法 = 47000,
        攻击 = 150 + 等级 * 30,
        速度 = 1 + 等级 * 1,
        抗性 = {
            抗水 = -72,
            抗雷 = -72,
            抗火 = -72,
            抗风 = -72,
            抗震慑 = 17
        },
        技能 = { "失心狂乱" },
        施法几率 = 50,
        是否消失 = false,
    }
    for n = 1, 4 do
        local r = _小怪物属性[math.random(#_小怪物属性)]
        for k, v in pairs(r) do
            if type(v) == "function" then
                r[k] = v(等级, 转生)
            end
        end
        r.施法几率 = 50
        r.是否消失 = false
        table.insert(战斗单位, r)
    end
    return 战斗单位
end

local function 取蓝色妖王信息(玩家, 等级, 转生)
    local 战斗单位 = {}
    战斗单位[1] = {
        名称 = "蓝色妖王",
        外形 = 2026,
        等级 = 等级,
        气血 = 125845 + 等级 * 1000,
        魔法 = 47000,
        攻击 = 150 + 等级 * 30,
        速度 = 1 + 等级 * 1,
        抗性 = {
            抗水 = -72,
            抗雷 = -72,
            抗火 = -72,
            抗风 = -72,
            抗震慑 = 17
        },
        技能 = { "失心狂乱" },
        施法几率 = 50,
        是否消失 = false,
    }
    for n = 1, 4 do
        local r = _小怪物属性[math.random(#_小怪物属性)]
        for k, v in pairs(r) do
            if type(v) == "function" then
                r[k] = v(等级, 转生)
            end
        end
        r.施法几率 = 50
        r.是否消失 = false
        table.insert(战斗单位, r)
    end
    return 战斗单位
end

local function 取黑山妖王信息(玩家, 等级, 转生)
    local 战斗单位 = {}
    战斗单位[1] = {
        名称 = "黑山妖王",
        外形 = 2073,
        等级 = 等级,
        气血 = 32587 + 转生 * 50000 + 等级 * 5000,
        魔法 = 47000,
        攻击 = 150 + 等级 * 30,
        速度 = 50 + 等级 * 2,
        抗性 = {
            抗水 = -72,
            抗雷 = -72,
            抗火 = -72,
            抗风 = -72,
            抗震慑 = 17
        },
        技能 = { "龙卷雨击", "龙腾水溅" },
        施法几率 = 50,
        是否消失 = false,
    }
    for n = 1, 4 do
        local r = _小怪物属性[math.random(#_小怪物属性)]
        for k, v in pairs(r) do
            if type(v) == "function" then
                r[k] = v(等级, 转生)
            end
        end
        r.施法几率 = 50
        r.是否消失 = false
        table.insert(战斗单位, r)
    end
    return 战斗单位
end

function 任务:战斗初始化(玩家, NPC)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    if NPC.名称 == "万年熊王" then
        local t = 取万年熊王信息(玩家, 等级, 转生)
        for k, v in pairs(t) do
            local r = 生成战斗怪物(v)
            self:加入敌方(k, r)
        end
    elseif NPC.名称 == "三头妖王" then
        local t = 取三头妖王信息(玩家, 等级, 转生)
        for k, v in pairs(t) do
            local r = 生成战斗怪物(v)
            self:加入敌方(k, r)
        end
    elseif NPC.名称 == "蓝色妖王" then
        local t = 取蓝色妖王信息(玩家, 等级, 转生)
        for k, v in pairs(t) do
            local r = 生成战斗怪物(v)
            self:加入敌方(k, r)
        end
    elseif NPC.名称 == "黑山妖王" then
        local t = 取黑山妖王信息(玩家, 等级, 转生)
        for k, v in pairs(t) do
            local r = 生成战斗怪物(v)
            self:加入敌方(k, r)
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        local zg = self:取对象(101)
        if zg then
            for k, v in self:遍历我方() do
                if v.是否玩家 then
                    local r = v.对象.接口:取任务("日常_天庭任务")
                    if r then
                        r:打败怪物(v.对象.接口, zg.名称)
                    end
                end
            end
        end
    end
end

return 任务
