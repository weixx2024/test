-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-08-31 17:58:09
local _时辰 = { '子时', '丑时', '寅时', '卵时', '辰时', '巳时', '午时', '未时', '申时', '酉时',
    '戌时', '亥时' }
local _时刻 = { '一刻', '二刻', '三刻', '四刻', '五刻', '六刻', '七刻', '八刻' }
local _种族 = { '人', '魔', '仙' }
local _大怪 = { 2073, 2006, 2098, 2061, 2044, 2045 }
local _地图 = { 1174, 1173, 1110, 1193, 1213 }


local 任务 = {
    名称 = '日常_种族任务',
    别名 = '种族任务',
    类型 = '常规玩法',
    是否惩罚 = true
}

function 任务:任务初始化()

end

function 任务:任务取详情(玩家)
    if self.NPC then
        return string.format('#Y任务目的:#r#W速去#Y%s#W端掉#G#u#[%s|%s|%s|$%s#]#u#W(当前第#R%s#W次，剩余#R%d#W分钟)'
            , self.位置, self.MAP, self.x, self.y, self.怪名, 玩家.其它.种族次数, (self.时间 - os.time())
            // 60)
    end
    return string.format('由于行动迟缓，#Y%s#W已经逃之夭夭了。\n', self.怪名)
end

function 任务:任务取消(玩家)
    玩家.其它.种族次数 = 0
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
    self.怪名 = _时辰[math.random(#_时辰)] .. _时刻[math.random(#_时刻)] .. "反" .. _种族[玩家.种族] ..
        "团伙"
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)

    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.种族次数 = v.其它.种族次数 + 1
        if v.其它.种族次数 > 6 then
            v.其它.种族次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 1800
    self.外形 = _大怪[math.random(#_大怪)]
    self.NPC =
    map:添加NPC {
        队伍 = self.队伍,
        人数 = #self.队伍,
        名称 = self.怪名,
        外形 = self.外形,
        脚本 = 'scripts/task/常规玩法/日常_种族任务.lua',
        时长 = 1800,
        任务类型 = "种族",
        X = X,
        Y = Y,
        来源 = self
    }
    self.次数 = 玩家.其它.种族次数
    self.MAP = map.id
    self.x = X
    self.y = Y
    return true
end

function 任务:完成(玩家)
    self:掉落包(玩家, 玩家.其它.种族次数)
    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
    self:删除()
end

local _掉落 = { --所有几率总和不能大于总几率

        { 几率 = 3, 名称 = '补天神石', 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 5, 名称 = '神兵礼盒', 参数 = 1, 数量 = 1, 广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 11, 名称 = '天机密令', 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 12, 名称 = '盘古精铁', 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 13, 名称 = '高级金柳露', 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 23, 名称 = '天外飞石', 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 35, 名称 = '云罗帐', 参数 = 9, 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 36, 名称 = '武帝袍', 参数 = 9, 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 37, 名称 = '盘古石', 参数 = 9, 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 38, 名称 = '灵犀角', 参数 = 9, 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 40, 名称 = '千年寒铁', 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 60, 名称 = '蟠桃王', 禁止交易 = true,数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 80, 名称 = '人参果王',禁止交易 = true, 数量 = 1,广播 = '#R%s#c00FFFF在种族任务表现英勇，种族使者特意赏赐了一个#G#m(%s)[%s]#m#n#c00FFFF#50' },
        { 几率 = 150, 名称 = '人参果',禁止交易 = true, 数量 = 1},
        { 几率 = 150, 名称 = '蟠桃', 禁止交易 = true,数量 = 1 },
        { 几率 = 150, 名称 = '九彩云龙珠', 数量 = 1, 参数 = 130 },
        { 几率 = 150, 名称 = '内丹精华', 数量 = 1 },
        { 几率 = 150, 名称 = '血玲珑', 数量 = 1, 参数 = 125 },

}
function 任务:掉落包(玩家, 次数)
    local 银子 = math.floor(20000)
    local 经验 = math.floor(84521 * (1 + 次数 * 0.12)) -----84521
    local 法宝经验 = math.floor(140 + 次数 * 12)
    if 玩家.是否队长 then
        经验 = math.floor(经验 * 1.05)
        银子 = math.floor(银子 * 1.05)
    end
    local 总几率 = 2000
    玩家:添加任务经验(经验, "种族")
    玩家:添加银子(银子, "种族")
    玩家:添加法宝经验(法宝经验, "种族")
    for i, v in ipairs(_掉落) do
        if math.random(总几率) <= v.几率 then
            local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数 }
            if r then
                玩家:添加物品({ r })
                if v.广播 and type(v.广播) == "string" then
                    玩家:发送系统(v.广播, 玩家.名称, r.nid, r.名称)
                end
                break
            end
        else
            总几率 = 总几率 - v.几率
        end
    end
end

--===============================================
local 对话 = [[没想到我躲在这里，也会被你们发现#4
menu
1|妖孽，受死吧
2|我认错人了
]]



function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "种族" then
        local r = 玩家:取任务("日常_种族任务")
        if r and r.NPC == NPC.nid then
            return 对话
        end
        return "我认识你么？"
    end

end

function 任务:NPC菜单(玩家, i, NPC)
    if i == '1' then
        local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_种族任务.lua', self)
        玩家:自动任务_战斗结束(sf)
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.任务类型 == "种族" then
        local r = 玩家:取任务("日常_种族任务")
        if r and r.NPC == NPC.nid then
            local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_种族任务.lua', NPC)
            玩家:自动任务_战斗结束(sf)
            return
        end
        return "我认识你么？"
    end
end

--===============================================
local _小怪模型 = { 2108, 2107, 2109, 2110, 2106 }
local _怪物技能 = { "蛇蝎美人", "反间之计", "催眠咒", "夺命勾魂", "妖之魔力", "飞砂走石",
    "地狱烈火", "雷霆霹雳", "龙卷雨击",
    "魔之飞步" }
function 任务:战斗初始化(玩家, NPC)
    local 任务 = 玩家:取任务('日常_种族任务')
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local 怪物属性
    self.NPC_nid = NPC.nid
    if 任务 then
        怪物属性 = {
            外形 = NPC.外形,
            名称 = NPC.名称,
            等级 = 等级,
            气血 = 525484 + 转生 * 505484 + 等级 * 10000,
            魔法 = 62587 + 等级 * 1150,
            攻击 = 1,
            速度 = math.random(300, 500) + 转生 * 30 + 等级 * 2,
            抗性 = { 抗水 = -270, 抗雷 = -270, 抗火 = -270, 抗风 = -270, 抗震慑 = 45, 物理吸收 = 75, 抗混乱 = 75, 抗昏睡 = 75, 抗中毒 = -354 },
            技能 = { "天诛地灭", "九龙冰封", "九阴纯火", "袖里乾坤", "阎罗追命", "魔神附身",
                "含情脉脉","乾坤借速", "失心狂乱", "魔音摄心", "百日眠" },
            施法几率 = 50,
            是否消失 = false,
            内丹 = { '乘风破浪','浩然正气' ,'梅花三弄','红颜白发'}
        }


        self:加入敌方(1, 生成战斗怪物(怪物属性))
        local 小怪数量 = 4 + 任务.次数
        小怪数量 = 小怪数量 > 10 and 10 or 小怪数量
        for i = 1, 小怪数量 do
            怪物属性 = {
                外形 = _小怪模型[math.random(#_小怪模型)],
                名称 = "团伙喽啰",
                等级 = 等级,
                气血 = 425484 + 转生 * 505484 + 等级 * 9000,
                魔法 = 12587 + 等级 * 150,
                攻击 = 72 + 转生 * 50 + 等级 * 5,
                速度 = math.random(100, 300) + 转生 * 30 + 等级 * 2,
                抗性 = {
                    抗水 = -360,
                    抗雷 = -360,
                    抗火 = -360,
                    抗风 = -360,
                    物理吸收 = 60,
                    抗昏睡 = 70,
                    抗混乱 = 75,
                    抗震慑 = 35,
                    抗中毒 = -565,

                },
                技能 = { _怪物技能[math.random(#_怪物技能)] },
                施法几率 = 50,
                是否消失 = false,
                内丹 = { '乘风破浪','浩然正气' ,'梅花三弄','红颜白发'}
            }

            self:加入敌方(i + 1, 生成战斗怪物(怪物属性))
        end
    end
end

function 任务:战斗回合开始(dt)

end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("日常_种族任务")
                if r and r.NPC == self.NPC_nid then
                    r:完成(v.对象.接口)
                end
            end
        end
    end
end

return 任务
