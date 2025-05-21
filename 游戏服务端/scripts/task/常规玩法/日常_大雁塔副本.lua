local 任务 = {
    名称 = '日常_大雁塔副本',
    别名 = '大雁塔降魔',
    类型 = '副本任务',
}

function 任务:任务初始化()
end

function 任务:任务取详情(玩家)
    if self.地图 then
        if self.进度 == 1 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈1)
        elseif self.进度 == 2 then
            return string.format("请速去#G(%s,%s)#W组阵除妖,使用镇妖镜使妖魔现形", self.X, self.Y)
        elseif self.进度 == 3 then
            return string.format("怪物首领出现在#G(%s,%s)#W请火速前往消灭", self.X, self.Y)
        elseif self.进度 == 4 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈1)
        elseif self.进度 == 5 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈2)
        elseif self.进度 == 6 then
            return "四处逛逛,看看能不能找到偷画轴的妖怪"
        elseif self.进度 == 7 then
            return string.format("找到了丢失的画轴,快去还给#G%s#W吧", self.方丈2)
        elseif self.进度 == 8 then
            return string.format("快去#G(%s,%s)#W使用画轴，收服妖魔", self.X, self.Y)
        elseif self.进度 == 9 then
            return string.format("怪物首领出现在#G(%s,%s)#W请火速前往消灭", self.X, self.Y)
        elseif self.进度 == 10 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈2)
        elseif self.进度 == 11 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈3)
        elseif self.进度 == 12 then
            return string.format("#G#u#[1006|130|60|$火妖#]#u#W在#G(130，60)#W,速去降服。")
        elseif self.进度 == 13 then
            return string.format("#G#u#[1006|94|82|$金妖#]#u#W在#G(94，82)#W,速去降服。")
        elseif self.进度 == 14 then
            return string.format("#G#u#[1006|18|59|$木鬼#]#u#W在#G(18，59)#W,速去降服。")
        elseif self.进度 == 15 then
            return string.format("#G#u#[1006|85|65|$尘魔#]#u#W在#G(85，65)#W,速去降服。")
        elseif self.进度 == 16 then
            return string.format("#G#u#[1006|67|29|$水妖#]#u#W在#G(67，29)#W,速去降服。")
        elseif self.进度 == 17 then
            return string.format("怪物首领出现在#G(%s,%s)#W,请火速前往消灭。", self.X, self.Y)
        elseif self.进度 == 18 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈3)
        elseif self.进度 == 19 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈4)
        elseif self.进度 == 20 then
            return string.format("巫支祁出现在#G(%s,%s)#W,速去铲除，当心沿途游荡的妖魔。", self.X,
                self.Y)
        elseif self.进度 == 21 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈4)
        elseif self.进度 == 22 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈5)
        elseif self.进度 == 23 then
            return string.format("速去#G(%s,%s)#W消灭奢比尸,小心沿途的妖魔,", self.X,
                self.Y)
        elseif self.进度 == 24 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈5)
        elseif self.进度 == 25 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈6)
        elseif self.进度 == 26 then
            return string.format("速去#G(%s,%s)#W消灭烛九阴,小心沿途的妖魔,", self.X,
                self.Y)
        elseif self.进度 == 27 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈6)
        elseif self.进度 == 28 then
            return string.format("#G%s#W正在等你们，好像有什么事情，快去找他", self.方丈7)
        elseif self.进度 == 29 then
            return string.format("速去#G(%s,%s)#W消灭三尸神,小心沿途的妖魔,", self.X,
                self.Y)
        end
    end
    return ""
end

function 任务:任务取消(玩家)
    for i, v in ipairs(self.地图) do
        if 玩家.地图 == self.地图.id then
            玩家:切换地图(1001, 103, 199)
        end
    end

    self:删除()
end

function 任务:任务更新(sec, 玩家)
    if os.time() > self.时间 then
        玩家:切换地图(1001, 103, 199)
        self:删除()
    end
end


function 任务:任务上线(玩家)

    if os.time() > self.时间 then
        玩家:切换地图(1001, 103, 199)
        self:删除()
    else
        self:生成地图(玩家)
    end
end

function 任务:任务下线(玩家)
end

function 任务:添加任务(玩家)
    self.时间 = os.time() + 3600
    self.进度 = 1
    self:生成地图(玩家)

    for i, v in 玩家:遍历队伍() do
        v:添加任务(self)
    end

    local map = self.地图[1]
    玩家:切换地图2(map, 20, 20)

    return true
end

function 任务:生成地图(玩家)
    self.地图 = {
        生成地图(1004),
        生成地图(1005),
        生成地图(1006),
        生成地图(1007),
        生成地图(1008),
        生成地图(1090),
        生成地图(1009),
    }

    self.地图[1]:添加NPC {
        名称 = "慈恩寺方丈",
        外形 = 3031,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_1.lua',
        X = 136,
        Y = 70,
        层数 = 1,
        方向 = 2,
        来源 = self,
    }
    self.方丈1 = string.format("#G#u#[1004|136|70|$慈恩寺方丈#]#u#W")

    self.地图[2]:添加NPC {
        名称 = "慈恩寺方丈",
        外形 = 3031,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_2.lua',
        X = 85,
        Y = 53,
        层数 = 2,
        方向 = 2,
        来源 = self,
    }
    self.方丈2 = string.format("#G#u#[1005|85|53|$慈恩寺方丈#]#u#W")

    self.地图[3]:添加NPC {
        名称 = "慈恩寺方丈",
        外形 = 3031,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_3.lua',
        X = 22,
        Y = 40,
        层数 = 3,
        方向 = 2,
        来源 = self,
    }
    self.方丈3 = string.format("#G#u#[1006|22|40|$慈恩寺方丈#]#u#W")


    self.地图[4]:添加NPC {
        名称 = "慈恩寺方丈",
        外形 = 3031,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_4.lua',
        X = 36,
        Y = 30,
        层数 = 4,
        方向 = 2,
        来源 = self,
    }
    self.方丈4 = string.format("#G#u#[1007|36|30|$慈恩寺方丈#]#u#W")

    self.地图[5]:添加NPC {
        名称 = "慈恩寺方丈",
        外形 = 3031,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_5.lua',
        X = 46,
        Y = 58,
        层数 = 5,
        方向 = 2,
        来源 = self,
    }
    self.方丈5 = string.format("#G#u#[1008|46|58|$慈恩寺方丈#]#u#W")

    self.地图[6]:添加NPC {
        名称 = "慈恩寺方丈",
        外形 = 3031,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_6.lua',
        X = 78,
        Y = 56,
        层数 = 6,
        方向 = 2,
        来源 = self,
    }
    self.方丈6 = string.format("#G#u#[1090|78|56|$慈恩寺方丈#]#u#W")

    self.地图[7]:添加NPC {
        名称 = "慈恩寺方丈",
        外形 = 3031,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_7.lua',
        X = 7,
        Y = 15,
        层数 = 6,
        方向 = 2,
        来源 = self,
    }
    self.方丈7 = string.format("#G#u#[1009|7|15|$慈恩寺方丈#]#u#W")




    self.地图[3]:添加NPC {
        名称 = "尘魔",
        外形 = 2292,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_3尘魔.lua',
        X = 85,
        Y = 65,
        层数 = 3,
        方向 = 2,
        来源 = self,
    }
    self.地图[3]:添加NPC {
        名称 = "木鬼",
        外形 = 2289,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_3木鬼.lua',
        X = 18,
        Y = 59,
        层数 = 3,
        方向 = 2,
        来源 = self,
    }
    self.地图[3]:添加NPC {
        名称 = "水妖",
        外形 = 2290,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_3水妖.lua',
        X = 67,
        Y = 29,
        层数 = 3,
        方向 = 2,
        来源 = self,
    }
    self.地图[3]:添加NPC {
        名称 = "火妖",
        外形 = 2291,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_3火妖.lua',
        X = 130,
        Y = 60,
        层数 = 3,
        方向 = 2,
        来源 = self,
    }
    self.地图[3]:添加NPC {
        名称 = "金妖",
        外形 = 2288,
        脚本 = 'scripts/npc/副本/大雁塔/大雁塔_3金妖.lua',
        X = 94,
        Y = 82,
        层数 = 3,
        方向 = 2,
        来源 = self,
    }
end

function 任务:刷出怪物(n)
    if n == 1 then
        local NPC = self.地图[1]:添加NPC {
            名称 = "玄蜂",
            外形 = 2367,
            脚本 = 'scripts/npc/副本/大雁塔/大雁塔_1怪.lua',
            X = self.X,
            Y = self.Y,
            来源 = self,
        }
        self.进度 = 3
        self.NPC = NPC.nid
    elseif n == 2 then
        local NPC = self.地图[2]:添加NPC {
            名称 = "虚耗",
            外形 = 2021,
            脚本 = 'scripts/npc/副本/大雁塔/大雁塔_2怪.lua',
            X = self.X,
            Y = self.Y,
            来源 = self,
        }
        self.进度 = 9
        self.NPC = NPC.nid
    elseif n == 17 then
        local NPC = self.地图[3]:添加NPC {
            名称 = "禺疆",
            外形 = 2170,
            脚本 = 'scripts/npc/副本/大雁塔/大雁塔_3禺疆.lua',
            X = self.X,
            Y = self.Y,
            来源 = self,
        }
        self.NPC = NPC.nid
    elseif n == 20 then
        local NPC = self.地图[4]:添加NPC {
            名称 = "巫支祁",
            外形 = 2090,
            脚本 = 'scripts/npc/副本/大雁塔/大雁塔_4怪.lua',
            X = self.X,
            Y = self.Y,
            来源 = self,
        }
        self.NPC = NPC.nid
    elseif n == 23 then
        local NPC = self.地图[5]:添加NPC {
            名称 = "奢比尸",
            外形 = 2089,
            脚本 = 'scripts/npc/副本/大雁塔/大雁塔_5怪.lua',
            X = self.X,
            Y = self.Y,
            来源 = self,
        }
        self.NPC = NPC.nid
    elseif n == 26 then
        local NPC = self.地图[6]:添加NPC {
            名称 = "烛九阴",
            外形 = 2452,
            脚本 = 'scripts/npc/副本/大雁塔/大雁塔_6怪.lua',
            X = self.X,
            Y = self.Y,
            来源 = self,
        }
        self.NPC = NPC.nid
    elseif n == 29 then
        local NPC = self.地图[7]:添加NPC {
            名称 = "三尸神",
            外形 = 2176,
            脚本 = 'scripts/npc/副本/大雁塔/大雁塔_7怪.lua',
            X = self.X,
            Y = self.Y,
            来源 = self,
        }
        self.NPC = NPC.nid
    end
end

function 任务:完成一层(玩家)
    self.进度 = 4
    self.地图[1]:删除NPC(self.NPC)
    local 经验 = 1500000
    local 大雁塔积分 = 20
    local r = 玩家:取任务('日常_大雁塔副本')
    if r then
        for i, v in 玩家:遍历队伍() do
            local rr = v:取任务("日常_大雁塔副本")
            if rr and rr.nid == r.nid then
                if v:取活动限制次数('大雁塔一层') < 1 then
                    v:增加活动限制次数('大雁塔一层')
                    v:添加任务经验(经验, "大雁塔")
                    v:添加指定积分(大雁塔积分, "大雁塔积分")
                end
            end
        end
    end
end

function 任务:完成二层(玩家)
    self.进度 = 10
    self.地图[2]:删除NPC(self.NPC)
    local 经验 = 2000000
    local 大雁塔积分 = 40
    local r = 玩家:取任务('日常_大雁塔副本')
    if r then
        for i, v in 玩家:遍历队伍() do
            local rr = v:取任务("日常_大雁塔副本")
            if rr and rr.nid == r.nid then
                if v:取活动限制次数('大雁塔二层') < 1 then
                    v:增加活动限制次数('大雁塔二层')
                    v:添加任务经验(经验, "大雁塔")
                    v:添加指定积分(大雁塔积分, "大雁塔积分")
                end
            end
        end
    end
end

function 任务:完成三层(玩家)
    self.进度 = 18
    self.地图[3]:删除NPC(self.NPC)
    local 经验 = 2500000
    local 大雁塔积分 = 120
    local r = 玩家:取任务('日常_大雁塔副本')
    if r then
        for i, v in 玩家:遍历队伍() do
            local rr = v:取任务("日常_大雁塔副本")
            if rr and rr.nid == r.nid then
                if v:取活动限制次数('大雁塔三层') < 1 then
                    v:增加活动限制次数('大雁塔三层')
                    v:添加任务经验(经验, "大雁塔")
                    v:添加指定积分(大雁塔积分, "大雁塔积分")
                end
            end
        end
    end
end

function 任务:完成四层(玩家)
    self.进度 = 21
    self.地图[4]:删除NPC(self.NPC)
    local 经验 = 3000000
    local 大雁塔积分 = 240
    local r = 玩家:取任务('日常_大雁塔副本')
    if r then
        for i, v in 玩家:遍历队伍() do
            local rr = v:取任务("日常_大雁塔副本")
            if rr and rr.nid == r.nid then
                if v:取活动限制次数('大雁塔四层') < 1 then
                    v:增加活动限制次数('大雁塔四层')
                    v:添加任务经验(经验, "大雁塔")
                    v:添加指定积分(大雁塔积分, "大雁塔积分")
                end
            end
        end
    end
end

function 任务:完成五层(玩家)
    self.进度 = 24
    self.地图[5]:删除NPC(self.NPC)
    local 经验 = 4000000
    local 大雁塔积分 = 400
    local r = 玩家:取任务('日常_大雁塔副本')
    if r then
        for i, v in 玩家:遍历队伍() do
            local rr = v:取任务("日常_大雁塔副本")
            if rr and rr.nid == r.nid then
                if v:取活动限制次数('大雁塔五层') < 1 then
                    v:增加活动限制次数('大雁塔五层')
                    v:添加任务经验(经验, "大雁塔")
                    v:添加指定积分(大雁塔积分, "大雁塔积分")
                end
            end
        end
    end
end

function 任务:完成六层(玩家)
    self.进度 = 27
    self.地图[6]:删除NPC(self.NPC)
    local 经验 = 5000000
    local 大雁塔积分 = 450
    local r = 玩家:取任务('日常_大雁塔副本')
    if r then
        for i, v in 玩家:遍历队伍() do
            local rr = v:取任务("日常_大雁塔副本")
            if rr and rr.nid == r.nid then
                if v:取活动限制次数('大雁塔六层') < 1 then
                    v:增加活动限制次数('大雁塔六层')
                    v:添加任务经验(经验, "大雁塔")
                    v:添加指定积分(大雁塔积分, "大雁塔积分")
                    rr:删除()
                end
            end
        end
    end
    玩家:切换地图(1001, 103, 199)
end

function 任务:完成七层(玩家)
    local 经验 = 6000000
    local 大雁塔积分 = 500
    local r = 玩家:取任务('日常_大雁塔副本')
    if r then
        for i, v in 玩家:遍历队伍() do
            local rr = v:取任务("日常_大雁塔副本")
            if rr and rr.nid == r.nid then
                if v:取活动限制次数('大雁塔七层') < 1 then
                    v:增加活动限制次数('大雁塔七层')
                    v:添加任务经验(经验, "大雁塔")
                    v:添加指定积分(大雁塔积分, "大雁塔积分")
                end
            end
        end
    end
    玩家:切换地图(1001, 103, 199)
end

function 任务:获取镜子(玩家)
    local x, y = self.地图[1]:随机坐标()
    self.X = x
    self.Y = y
    if 玩家:添加物品({ 生成物品 { 名称 = '镇妖镜', x = x, y = y, mapid = self.地图[1].id, 数量 = 1 } }) then
        self.进度 = 2
        return true
    end
end

function 任务:改变进度(n)
    self.进度 = n
    if self.进度 == 8 then
        self.X, self.Y = self.地图[2]:随机坐标()
    elseif self.进度 == 17 then
        self.X, self.Y = self.地图[3]:随机坐标()
        self:刷出怪物(17)
    elseif self.进度 == 20 then
        self.X, self.Y = self.地图[4]:随机坐标()
        self:刷出怪物(20)
    elseif self.进度 == 23 then
        self.X, self.Y = 129, 63
        self:刷出怪物(23)
    elseif self.进度 == 26 then
        self.X, self.Y = 48, 55
        self:刷出怪物(26)
    elseif self.进度 == 29 then
        self.X, self.Y = 19, 21
        self:刷出怪物(29)
    end
end

local _传送坐标 = {
    [1] = { 20, 20 },
    [2] = { 75, 80 },
    [3] = { 74, 59 },
    [4] = { 37, 28 },
    [5] = { 75, 57 },
    [6] = { 128, 47 },
    [7] = { 21, 13 },
}

function 任务:进场(玩家, 层)
    if not self.地图 then
        self:生成地图(玩家)
    end
    if not 层 then
        if self.层数 then
            local map = self.地图[self.层数]
            玩家:切换地图2(map, table.unpack(_传送坐标[self.层数]))
        else
            local map = self.地图[1]
            self.层数 = 1
            玩家:切换地图2(map, 20, 20)
        end
        return
    end

    if 层 == 2 then
        local map = self.地图[2]
        self.层数 = 2
        玩家:切换地图2(map, 75, 80)
        if self.进度 == 4 then
            self.进度 = 5
        end
    elseif 层 == 3 then
        local map = self.地图[3]
        self.层数 = 3
        玩家:切换地图2(map, 74, 59)
        if self.进度 == 10 then
            self.进度 = 11
        end
    elseif 层 == 4 then
        local map = self.地图[4]
        self.层数 = 4
        玩家:切换地图2(map, 37, 28)
        if self.进度 == 18 then
            self.进度 = 19
        end
    elseif 层 == 5 then
        local map = self.地图[5]
        self.层数 = 5
        玩家:切换地图2(map, 75, 57)
        if self.进度 == 21 then
            self.进度 = 22
        end
    elseif 层 == 6 then
        local map = self.地图[6]
        self.层数 = 6
        玩家:切换地图2(map, 128, 47)
        if self.进度 == 24 then
            self.进度 = 25
        end
    elseif 层 == 7 then
        self.层数 = 7
        local map = self.地图[7]
        玩家:切换地图2(map, 21, 13)
        if self.进度 == 27 then
            self.进度 = 28
        end
    end
end

function 任务:地图刷新事件(玩家, map)
    if not self.遇敌时间 then
        self.遇敌时间 = 0
    end

    if self.进度 == 6 and 玩家.是否队长 then
        if map.是否副本 then
            self.遇敌时间 = self.遇敌时间 + math.random(1, 3)
            if self.遇敌时间 > 10 then
                self.遇敌时间 = 0
                local r = 玩家:进入战斗("scripts/war/大雁塔/大雁塔_2遇敌.lua")
                if r and math.random(80) <= 100 then
                    if 玩家:添加物品({ 生成物品 { 名称 = "聚魄画轴", 数量 = 1 } }) then
                        self.进度 = 7
                    end
                end
            end
        end
    end
end

return 任务
