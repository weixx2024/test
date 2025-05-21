local _时辰 = { '子时', '丑时', '寅时', '卵时', '辰时', '巳时', '午时', '未时', '申时', '酉时',
    '戌时', '亥时' }
local _时刻 = { '一刻', '二刻', '三刻', '四刻', '五刻', '六刻', '七刻', '八刻' }
local _小怪 = { '诌鬼', '假鬼', '奸鬼', '捣蛋鬼', '冒失鬼', '烟沙鬼', '挖渣鬼', '仔细鬼', '讨吃鬼',
    '醉死鬼', '抠掏鬼', '伶俐鬼', '急突鬼', '丢谎鬼', '乜斜鬼', '撩桥鬼', '饿鬼', '色鬼', '穷鬼',
    '刻山鬼', '吸血鬼', '惊鸿鬼', '清明鬼' }
local _大怪 = { 2054, 2058, 2051, 2049, 2056, 2055, 2050, 2073 }
--"孤魂","吸血鬼","幽灵","冤魂","无头鬼","野鬼","修罗","千年老妖"
local _地图 = { 1193, 1203, 1478 ,1070, 1091, 1110, 1140 }   ----, 1070, 1091, 1110, 1140
--长安城东， 斧头帮，大唐边境       ，长寿村，长寿村外，大唐境内，普陀山

local 任务 = {
    名称 = '日常_抓鬼任务',
    别名 = '抓鬼任务',
    类型 = '常规玩法'
}

function 任务:任务初始化()

end

function 任务:任务取详情(玩家)
    if self.NPC then
        return string.format('#Y任务目的:#r#W请前往#Y%s#W场景，捉拿#G#u#[%s|%s|%s|$%s#]#u#W(当前第#R%s#W次，剩余#R%d#W分钟)'
            , self.位置, self.MAP, self.x, self.y, self.怪名, 玩家.其它.抓鬼次数, (self.时间 - os.time())
            // 60)
    end
    return string.format('由于行动迟缓，#Y%s#W已经逃之夭夭了。\n', self.怪名)
end

function 任务:任务取消(玩家)
    玩家.其它.抓鬼次数 = 0
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
    self.怪名 = _时辰[math.random(#_时辰)] .. _时刻[math.random(#_时刻)] .. _小怪[math.random(#_小怪)]
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)

    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.抓鬼次数 = v.其它.抓鬼次数 + 1
        if v.其它.抓鬼次数 > 7 then
            v.其它.抓鬼次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.外形 = _大怪[math.random(#_大怪)]
    self.NPC =
        map:添加NPC {
            队伍 = self.队伍,
            人数 = #self.队伍,
            名称 = self.怪名,
            时长 = 1800,
            外形 = self.外形,
            脚本 = 'scripts/task/常规玩法/日常_抓鬼任务.lua',
            时间 = self.时间,
            任务类型 = "小鬼",
            X = X,
            Y = Y,
            来源 = self
        }
    self.次数 = 玩家.其它.抓鬼次数
    self.MAP = map.id
    self.x = X
    self.y = Y
    玩家:自动任务({
        类型 = "日常_抓鬼任务",
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
    self:掉落包(玩家, 玩家.其它.抓鬼次数)
    r = 玩家:取任务('新手剧情')
    if r then
        r:完成抓鬼(玩家)
    end
    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
    self:删除()
end

local _广播 = '#C%s#c00FFFF在钟馗抓鬼任务中表现出色，赐予#G#m(%s)[%s]#m#n#c00FFFF以示鼓励!'

function 任务:掉落包(玩家, 次数)
    if 玩家:判断等级是否高于(70) then
        return
    end

    local 师贡 = math.floor(2000 * (1 + 次数 * 0.22))
    local 银子 = math.floor(1000 * (1 + 次数 * 0.22))
    local 经验 = math.floor(84521 * (1 + 次数 * 0.12))
    local 法宝经验 = math.floor(140 + 次数 * 12)

    if 玩家.是否队长 then
        经验 = math.floor(经验 * 1.05)
        师贡 = math.floor(师贡 * 1.05)
        银子 = math.floor(银子 * 1.05)
        local t = 玩家:取物品是否存在('三界符')
        if not t then
            玩家:添加物品({ 生成物品 { 名称 = '三界符', 数量 = 1 } })
        end
    end

    玩家:添加任务经验(经验, "抓鬼")
    玩家:添加法宝经验(法宝经验, "抓鬼")
    玩家:添加坐骑经验(1)

    玩家:增加活动限制次数('抓鬼任务')
    if 玩家:取活动限制次数('抓鬼任务') > 150 then
        return
    end

    玩家:添加师贡(师贡, "抓鬼")
    玩家:添加银子(银子, "抓鬼")

    local 掉落包 = 取掉落包('日常', '抓鬼任务')
    if 掉落包 then
        奖励掉落包物品(玩家, 掉落包, _广播)
    end
end

--===============================================
local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧#126
2|我认错人了#76
]]

function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "小鬼" then
        local r = 玩家:取任务("日常_抓鬼任务")
        if r and r.NPC == NPC.nid then
            return 对话
        end
        return "我认识你么？"
    end
end

function 任务:NPC菜单(玩家, i, NPC)
    if i == '1' then
        local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_抓鬼任务.lua', self)
        玩家:自动任务_战斗结束(sf)
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.任务类型 == "小鬼" then
        local r = 玩家:取任务("日常_抓鬼任务")
        if r and r.NPC == NPC.nid then
            local sf = 玩家:进入战斗('scripts/task/常规玩法/日常_抓鬼任务.lua', NPC)
            玩家:自动任务_战斗结束(sf)
            return
        end
        return "我认识你么？"
    end
end

--===============================================

local _怪物技能 = { "蛇蝎美人", "反间之计", "催眠咒", "夺命勾魂", "妖之魔力", "飞砂走石", "地狱烈火", "雷霆霹雳", "龙卷雨击", "魔之飞步" }

function 任务:战斗初始化(玩家, NPC)
    local 任务 = 玩家:取任务('日常_抓鬼任务')
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    self.NPC_nid = NPC.nid
    if 任务 then
        local 怪物属性 = {
            外形 = NPC.外形,
            名称 = NPC.名称,
            等级 = 等级,
            气血 = 12587 + 转生 * 10000 + 等级 * 100,
            魔法 = 12587 + 等级 * 150,
            攻击 = 132 + 转生 * 50 + 等级 * 5,
            速度 = math.random(50, 100) + 转生 * 50 + 等级 * 2,
            抗性 = {
                抗水 = -32,
                抗雷 = -32,
                抗火 = -32,
                抗风 = -32
            },
            技能 = { "追魂迷香", "情真意切", "追神摄魄", "瞌睡咒", "力神复苏", "莲步轻舞",
                "急速之魔",
                "乘风破浪", "天雷怒火", "日照光华", "龙腾水溅" },
            施法几率 = 50,
            是否消失 = false,
        }


        self:加入敌方(1, 生成战斗怪物(怪物属性))

        for i = 1, 4 + math.floor(任务.次数 * 0.1) do
            local 怪物属性 = {
                外形 = _大怪[math.random(#_大怪)],
                名称 = _时辰[math.random(#_时辰)] .. _时刻[math.random(#_时刻)] .. _小怪[math.random(#_小怪)
                ],
                等级 = 等级,
                气血 = 12587 + 转生 * 10000 + 等级 * 50,
                魔法 = 12587 + 等级 * 150,
                攻击 = 72 + 转生 * 50 + 等级 * 5,
                速度 = math.random(10, 50) + 转生 * 30 + 等级 * 2,
                抗性 = {
                    抗水 = -39,
                    抗雷 = -39,
                    抗火 = -39,
                    抗风 = -39
                },
                技能 = { _怪物技能[math.random(#_怪物技能)] },
                施法几率 = 50,
                是否消失 = false,
            }

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
                local r = v.对象.接口:取任务("日常_抓鬼任务")
                if r and r.NPC == self.NPC_nid then
                    r:完成(v.对象.接口)
                end
            end
        end
    end
end

return 任务
