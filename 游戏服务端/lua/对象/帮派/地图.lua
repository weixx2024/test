local 帮派 = require('帮派')
-- [001218] = { name = '初级帮派', w = 3200, h = 2400, min = 0, max = 0, music = 1033, bg = 104001 },
-- [001219] = { name = '中级帮派', w = 3200, h = 2400, min = 0, max = 0, music = 1033, bg = 104001 },
-- [001220] = { name = '金库', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001221] = { name = '聚义厅', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001222] = { name = '密室', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001223] = { name = '磨房', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001224] = { name = '神殿', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001225] = { name = '厢房', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001226] = { name = '高级帮派', w = 3200, h = 2400, min = 0, max = 0, music = 1033, bg = 104001 },
-- [001227] = { name = '金库', w = 640, h = 480, min = 0, music = 1033, bg = 104000 },
-- [001228] = { name = '聚义厅', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001229] = { name = '密室', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001230] = { name = '磨房', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001231] = { name = '神殿', w = 1280, h = 960, min = 0, max = 0, music = 1033, bg = 104000 },
-- [001232] = { name = '厢房', w = 640, h = 480, min = 0, max = 0, music = 1033, bg = 104000 },
local _等级地图 = { 1218, 1219, 1219, 1226 }
function 帮派:创建高级帮派地图()
    self.地图 = __沙盒.生成地图(1226)
    self.地图.是否帮派 = true --用于下线的时候处理下次上线的位置
    self.地图:添加NPC {
        名称 = "坐骑驯养师",
        外形 = 3061,
        脚本 = 'scripts/npc/帮派/坐骑驯养师.lua',
        X = 130,
        Y = 45,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "召唤兽驯养师",
        外形 = 3061,
        脚本 = 'scripts/npc/帮派/召唤兽驯养师.lua',
        X = 125,
        Y = 43,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "宠物驯养师",
        外形 = 3043,
        脚本 = 'scripts/npc/帮派/宠物驯养师.lua',
        X = 136,
        Y = 46,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "帮派守护神",
        外形 = 2070,
        脚本 = 'scripts/npc/帮派/守护神.lua',
        X = 55,
        Y = 69,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "帮派总管",
        外形 = 3011,
        脚本 = 'scripts/npc/帮派/总管.lua',
        X = 24,
        Y = 86,
        帮派 = self
    }

    self.地图:添加NPC {
        名称 = "帮派账房先生",
        外形 = 3011,
        脚本 = 'scripts/npc/帮派/账房先生.lua',
        X = 66,
        Y = 105,
        帮派 = self
    }
    self.地图:添加跳转({
        X = 150,
        Y = 7,
        tid = 1001,
        tX = 207,
        tY = 70
    })
end

function 帮派:创建中级帮派地图()
    self.地图 = __沙盒.生成地图(1219)
    self.地图.是否帮派 = true --用于下线的时候处理下次上线的位置
    self.地图:添加NPC {
        名称 = "坐骑驯养师",
        外形 = 3061,
        脚本 = 'scripts/npc/帮派/坐骑驯养师.lua',
        X = 130,
        Y = 45,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "宠物驯养师",
        外形 = 3043,
        脚本 = 'scripts/npc/帮派/宠物驯养师.lua',
        X = 136,
        Y = 46,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "召唤兽驯养师",
        外形 = 3061,
        脚本 = 'scripts/npc/帮派/召唤兽驯养师.lua',
        X = 125,
        Y = 43,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "帮派守护神",
        外形 = 2070,
        脚本 = 'scripts/npc/帮派/守护神.lua',
        X = 55,
        Y = 69,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "帮派总管",
        外形 = 3011,
        脚本 = 'scripts/npc/帮派/总管.lua',
        X = 24,
        Y = 86,
        帮派 = self
    }

    self.地图:添加NPC {
        名称 = "帮派账房先生",
        外形 = 3011,
        脚本 = 'scripts/npc/帮派/账房先生.lua',
        X = 66,
        Y = 105,
        帮派 = self
    }
    self.地图:添加跳转({
        X = 150,
        Y = 7,
        tid = 1001,
        tX = 207,
        tY = 70
    })
end

function 帮派:创建初级帮派地图()
    self.地图 = __沙盒.生成地图(1218)
    self.地图.是否帮派 = true --用于下线的时候处理下次上线的位置
    self.地图:添加NPC {
        名称 = "坐骑驯养师",
        外形 = 3061,
        脚本 = 'scripts/npc/帮派/坐骑驯养师.lua',
        X = 130,
        Y = 45,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "宠物驯养师",
        外形 = 3043,
        脚本 = 'scripts/npc/帮派/宠物驯养师.lua',
        X = 136,
        Y = 46,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "召唤兽驯养师",
        外形 = 3061,
        脚本 = 'scripts/npc/帮派/召唤兽驯养师.lua',
        X = 125,
        Y = 43,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "帮派守护神",
        外形 = 2070,
        脚本 = 'scripts/npc/帮派/守护神.lua',
        X = 55,
        Y = 69,
        帮派 = self
    }
    self.地图:添加NPC {
        名称 = "帮派总管",
        外形 = 3011,
        脚本 = 'scripts/npc/帮派/总管.lua',
        X = 24,
        Y = 86,
        帮派 = self
    }

    self.地图:添加NPC {
        名称 = "帮派账房先生",
        外形 = 3011,
        脚本 = 'scripts/npc/帮派/账房先生.lua',
        X = 66,
        Y = 105,
        帮派 = self
    }
    self.地图:添加跳转({
        X = 150,
        Y = 7,
        tid = 1001,
        tX = 207,
        tY = 70
    })
end

function 帮派:置帮战地图(map, name)
    if map then
        self.帮战地图 = map
        self.敌对帮派 = name
    end
end

function 帮派:强制结束帮战()
    if self.帮战地图 then
        local a = self.帮战地图:取同帮玩家数量(self.名称)
        local b = self.帮战地图:取同帮玩家数量(self.敌对帮派)
        local 胜利 = false
        if a > b then
            胜利 = true
        elseif a == b then
            胜利 = math.random(10) < 5
        end
        if 胜利 then
            self:帮战胜利奖励()
        else
            self:帮战失败奖励()
        end
        -- self.帮战地图:清空玩家(1001, 357, 55)
        -- self.帮战地图 = nil
    end
end

function 帮派:清除帮战地图()
    if self.帮战地图 then
        self.帮战地图:清空玩家(1001, 357, 55)
        self.帮战地图 = nil
    end
end
