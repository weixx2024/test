local _时辰 = { '子时', '丑时', '寅时', '卵时', '辰时', '巳时', '午时', '未时', '申时', '酉时',
    '戌时', '亥时' }
local _时刻 = { '一刻', '二刻', '三刻', '四刻', '五刻', '六刻', '七刻', '八刻' }
local _小怪 = { '诌鬼王', '假鬼王', '奸鬼王', '捣蛋鬼王', '冒失鬼王', '烟沙鬼王', '挖渣鬼王',
    '仔细鬼王', '讨吃鬼王', '醉死鬼王', '抠掏鬼王', '伶俐鬼王', '急突鬼王', '丢谎鬼王',
    '乜斜鬼王', '撩桥鬼王', '饿鬼王', '色鬼王', '穷鬼王', '刻山鬼王', '吸血鬼王', '惊鸿鬼王',
    '清明鬼王' }

local _外形 = { 2089, 2056, 2055, 2049, 2050, 2051, 2115, 2109 }
--"九头魔",无头鬼, 野鬼, 冤魂, 修罗, 幽灵, 范式之魂, 剑精灵
local _地图 = { 1177, 1178, 1179, 1180, 1186, 1187, 1188, 1189, 1199, 1198, 1201, 1217 }
--龙窟一层, 龙窟二层, 龙窟三层, 龙窟四层, 凤巢一层, 凤巢二层, 凤巢三层, 凤巢四层, 御马监, 瑶池, 蟠桃园, 蟠桃园后

local 任务 = {
    名称 = '日常_鬼王任务',
    别名 = '鬼王任务',
    类型 = '常规玩法'
}

function 任务:任务初始化()

end

function 任务:任务取详情(玩家)
    if self.NPC then
        return string.format(
            '#Y任务目的:#r#W刚收到鬼差信报，在#Y%s#W处发现#G#u#[%s|%s|%s|$%s#]#u#W为免其危害人间，我已下令招募三界有志之士前往捉拿，成功者重重有赏！这事情就有劳阁下了！(当前第#R%s#W次，剩余#R%d#W分钟)'
            , self.位置, self.MAP, self.x, self.y, self.怪名, 玩家.其它.鬼王次数, (self.时间 - os.time())
            // 60)
    end
    return string.format('由于行动迟缓，#Y%s#W已经逃之夭夭了。\n', self.怪名)
end

function 任务:任务取消(玩家)
    玩家.其它.鬼王次数 = 0
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

function 任务:任务更新(sec, 玩家)
    if sec > self.时间 then
        local map = 玩家:取地图(self.MAP)
        if map then
            local NPC = map:取NPC(self.NPC)
            if NPC then
                NPC:删除()
            end
        end
        self:删除()
    end
end

function 任务:生成怪物(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    self.怪名 = _时辰[math.random(#_时辰)] .. _时刻[math.random(#_时刻)] .. _小怪[math.random(#_小怪)]
    local X, Y = map:取随机坐标() --真坐标
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.鬼王次数 = v.其它.鬼王次数 + 1
        if v.其它.鬼王次数 > 7 then
            v.其它.鬼王次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.外形 = _外形[math.random(#_外形)]
    self.NPC =
        map:添加NPC {
            队伍 = self.队伍,
            人数 = #self.队伍,
            时长 = 1800,
            名称 = self.怪名,
            外形 = self.外形,
            脚本 = 'scripts/task/常规玩法/日常_鬼王任务.lua',
            时间 = self.时间,
            任务类型 = "鬼王",
            X = X,
            Y = Y,
            来源 = self
        }
    self.次数 = 玩家.其它.抓鬼次数
    self.MAP = map.id
    self.x = X
    self.y = Y


    玩家:自动任务({
        类型 = "日常_鬼王任务",
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
    self:掉落包(玩家, 玩家.其它.鬼王次数)
    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
    self:删除()
end

local _广播 = '#C%s#c00FFFF驱鬼有功，特将私藏多年的#G#m(%s)[%s]#m#n#c00FFFF赐予，作为嘉奖！'

function 任务:掉落包(玩家, 次数)
    if 玩家:判断等级是否高于(160) then
        return
    end

    local 师贡 = 15000 * (1 + 次数 * 0.12)
    local 银子 = 7500 * (1 + 次数 * 0.12)
    local 经验 = 292547 * (1 + 次数 * 0.14)
    local 法宝经验 = 240 + 次数 * 14

    local r = 玩家:取任务("引导_鬼王任务")
    if r then
        r:添加进度(玩家)
    end

    if 玩家.是否队长 then
        经验 = math.floor(经验 * 1.05)
        师贡 = math.floor(师贡 * 1.05)
        银子 = math.floor(银子 * 1.05)

        local t = 玩家:取物品是否存在('鬼狱灵反符')
        if not t then
            玩家:添加物品({ 生成物品 { 名称 = '鬼狱灵反符', 数量 = 1 } })
        end
    end

    玩家:添加任务经验(经验, "鬼王")
    玩家:添加法宝经验(法宝经验, "鬼王")
    玩家:添加坐骑经验(1)

    if 玩家:取活动限制次数('鬼王任务') > 100 then
        return
    end

    玩家:增加活动限制次数('鬼王任务')
    玩家:添加银子(银子, "鬼王")
    玩家:添加师贡(师贡, "鬼王")

    local 掉落包 = 取掉落包('日常', '鬼王任务')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包, _广播)
    end
end

--=====================对话==========================
local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]

function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "鬼王" then
        local r = 玩家:取任务('日常_鬼王任务')
        if r and r.NPC == self.来源.NPC then
            return 对话
        end
        return '我认识你么？#24'
    end
end

function 任务:NPC菜单(玩家, i)
    if i == '1' then
        local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_鬼王任务.lua', self)
        玩家:自动任务_战斗结束(sf)
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.任务类型 == "鬼王" then
        local r = 玩家:取任务("日常_鬼王任务")
        if r and r.NPC == NPC.nid then
            local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_鬼王任务.lua', NPC)
            玩家:自动任务_战斗结束(sf)
            return
        end
        return "我认识你么？"
    end
end

--===============================================
local _怪物技能 = { "断肠烈散", "魔音摄心", "狮王之怒", "楚楚可怜", "魔神飞舞", "太乙生风",
    "三味真火", "雷神怒击", "龙啸九天", "冥烟销骨", "追魂迷香", "情真意切", "瞌睡咒",
    "追神摄魄", "力神复苏", "莲步轻舞", "急速之魔", "乘风破浪", "天雷怒火", "日照光华",
    "龙腾水溅", "火影迷踪" }

function 任务:战斗初始化(玩家, NPC)
    local r = 玩家:取任务('日常_鬼王任务')
    self.NPC_nid = NPC.nid
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    if r then
        local 怪物属性 = {
            外形 = NPC.外形,
            名称 = NPC.名称,
            等级 = 等级,
            气血 = 56544 + 转生 * 150000 + 等级 * 5000,
            魔法 = 26000,
            攻击 = 10 + 等级 * 2,
            速度 = 5 + 等级 * 1,
            抗性 = {
                抗混乱 = 40,
                抗封印 = 40,
                抗中毒 = 40,
                抗水 = -80,
                抗雷 = -80,
                抗火 = -80,
                抗风 = -80,
                抗震慑 = 23,
                抗鬼火 = -30
            },
            技能 = {
                { 名称 = '太乙生风', 熟练度 = 10000 },
                { 名称 = '龙啸九天', 熟练度 = 10000 },
                { 名称 = '三味真火', 熟练度 = 10000 },
                { 名称 = '断肠烈散', 熟练度 = 10000 },
                { 名称 = '谗言相加', 熟练度 = 10000 },
                { 名称 = '雷神怒击', 熟练度 = 10000 },
                { 名称 = '离魂咒', 熟练度 = 10000 },
                { 名称 = '魔音摄心', 熟练度 = 10000 },
                { 名称 = '狮王之怒', 熟练度 = 10000 },
                { 名称 = '楚楚可怜', 熟练度 = 10000 },
                { 名称 = '魔神飞舞', 熟练度 = 10000 }
            },
            施法几率 = 50,
            是否消失 = false,
            --内丹 = { '乘风破浪' }
        }


        self:加入敌方(1, 生成战斗怪物(怪物属性))

        for i = 1, 5 + math.floor(r.次数 * 0.2) do
            local 怪物属性 = {
                外形 = _外形[math.random(#_外形)],
                名称 = _时辰[math.random(#_时辰)] .. _时刻[math.random(#_时刻)] .. _小怪[math.random(#_小怪)
                ],
                等级 = 等级,
                气血 = 56875 + 转生 * 100000 + 等级 * 3000,
                魔法 = 26000,
                攻击 = 10 + 等级 * 2,
                速度 = 5 + 等级 * 1,
                抗性 = {
                    抗混乱 = 40,
                    抗封印 = 40,
                    抗中毒 = 20,
                    抗水 = -95,
                    抗雷 = -95,
                    抗火 = -95,
                    抗风 = -95,
                    抗震慑 = 17,
                    抗鬼火 = -30
                },
                技能 = {},
                施法几率 = 50,
                是否消失 = false,
            }
            for _ = 1, math.random(3) do
                table.insert(怪物属性.技能, { 名称 = _怪物技能[math.random(#_怪物技能)], 熟练度 = 50000 })
            end
            local 怪物 = 生成战斗怪物(怪物属性)

            self:加入敌方(i + 1, 怪物)
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("日常_鬼王任务")
                if r and r.NPC == self.NPC_nid then
                    r:完成(v.对象.接口)
                end
            end
        end
    end
end

return 任务
