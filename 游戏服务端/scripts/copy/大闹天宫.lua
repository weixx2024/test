local 副本 = {
    名称 = '大闹天宫',
    类型 = 1, --1全服
    是否打开 = t,
}
function 副本:副本初始化()
    self.活动时 = "20"
    self.活动分 = "24"
    self.活动时长 = 7200
    self.进场开关 = false
    self.是否开始 = false
    self.花果山 = {
        成员列表 = {},
        军旗 = true,
        躲旗人 = false,
        出兵速度 = 120 * 1000,
        基地耐久 = 100,
        人数 = 0,
        箭塔 = { 100, 100, 100 }
    }
    self.天庭 = {
        成员列表 = {},
        军旗 = true,
        躲旗人 = false,
        出兵速度 = 120 * 1000,
        基地耐久 = 100,
        人数 = 0,
        箭塔 = { 100, 100, 100 }
    }
end

function 副本:更新(sec) --统一控制  开启  报名 进场 活动

end

function 副本:是否开启(sec)
    return self.是否开始
end

function 副本:开启进场()
    self.花果山 = {
        成员列表 = {},
        军旗 = true,
        躲旗人 = false,
        出兵速度 = 120 * 1000,
        基地耐久 = 100,
        人数 = 0,
        箭塔 = { 100, 100, 100 }
    }
    self.天庭 = {
        成员列表 = {},
        军旗 = true,
        躲旗人 = false,
        出兵速度 = 120 * 1000,
        基地耐久 = 100,
        人数 = 0,
        箭塔 = { 100, 100, 100 }
    }
    self.进场开关 = true
    发送系统("#R玄阴宝鉴已吸牧足够的玄阴之气,事不宜迟现在可以通过时空之门回到500年前。各位勇士可找洛阳玄阴仙子进入大闹天宫战场")
end

function 副本:开启活动(sec)

    发送系统("#R大闹天宫开始公告 等待出兵")


end

local _起始xy = { --天庭
    { 79, 178 },
    { 145, 188 },
    { 171, 219 }
}
local _起始xy2 = { --花果山
    { 319, 86 },
    { 329, 121 },
    { 391, 123 }
}
function 副本:测试刷怪()
    local map = 取地图(101385)
    for n = 1, 3, 1 do
        local 起始x, 起始y = _起始xy[n][1], _起始xy[n][2]
        for i = 1, 8, 1 do
            map:添加NPC {
                名称 = "天龙女",
                外形 = 2128,
                等级 = 80,
                脚本 = 'scripts/npc/大闹天宫/天龙女.lua',
                X = 起始x + math.random(3),
                Y = 起始y + math.random(3),
                行走开关 = true,
                行走时间 = os.time() + 2 + i * 2,
                行走间隔 = 2,
                路 = n,
                当前地图 = map,
                TX = 317,
                TY = 86,
                副本 = self
            }
        end
        for i = 1, 1, 1 do
            map:添加NPC {
                名称 = "多闻天王",
                外形 = 2126,
                等级 = 80,
                脚本 = 'scripts/npc/大闹天宫/多闻天王.lua',
                X = 起始x + math.random(3),
                Y = 起始y + math.random(3),
                行走开关 = true,
                行走时间 = os.time() + 2 + i * 2,
                行走间隔 = 2,
                路 = n,
                当前地图 = map,
                TX = 317,
                TY = 86,
                副本 = self
            }
        end
        for i = 1, 1, 1 do
            map:添加NPC {
                名称 = "哪吒太子",
                外形 = 2124,
                等级 = 80,
                脚本 = 'scripts/npc/大闹天宫/哪吒太子.lua',
                X = 起始x + math.random(3),
                Y = 起始y + math.random(3),
                行走开关 = true,
                行走时间 = os.time() + 2 + i * 2,
                行走间隔 = 2,
                路 = n,
                当前地图 = map,
                TX = 317,
                TY = 86,
                副本 = self
            }
        end




    end

    for n = 1, 3, 1 do
        local 起始x, 起始y = _起始xy2[n][1], _起始xy2[n][2]
        for i = 1, 8, 1 do
            map:添加NPC {
                名称 = "吉祥果",
                外形 = 2129,
                等级 = 80,
                脚本 = 'scripts/npc/大闹天宫/吉祥果.lua',
                X = 起始x + math.random(3),
                Y = 起始y + math.random(3),
                行走开关 = true,
                行走时间 = os.time() + 2 + i * 2,
                行走间隔 = 2,
                路 = n,
                当前地图 = map,
                TX = 317,
                TY = 86,
                副本 = self
            }
        end
        for i = 1, 1, 1 do
            map:添加NPC {
                名称 = "铁扇仙子",
                外形 = 2125,
                等级 = 80,
                脚本 = 'scripts/npc/大闹天宫/铁扇仙子.lua',
                X = 起始x + math.random(3),
                Y = 起始y + math.random(3),
                行走开关 = true,
                行走时间 = os.time() + 2 + i * 2,
                行走间隔 = 2,
                路 = n,
                当前地图 = map,
                TX = 317,
                TY = 86,
                副本 = self
            }
        end
        for i = 1, 1, 1 do
            map:添加NPC {
                名称 = "混世魔王",
                外形 = 2127,
                等级 = 80,
                脚本 = 'scripts/npc/大闹天宫/混世魔王.lua',
                X = 起始x + math.random(3),
                Y = 起始y + math.random(3),
                行走开关 = true,
                行走时间 = os.time() + 2 + i * 2,
                行走间隔 = 2,
                路 = n,
                当前地图 = map,
                TX = 317,
                TY = 86,
                副本 = self
            }
        end




    end




end

function 副本:天庭出兵()
    local map = 取地图(101385)
    for n = 1, 3, 1 do
        if self.天庭.箭塔[n] > 0 then
            local 起始x, 起始y = _起始xy[n][1], _起始xy[n][2]
            for i = 1, 8, 1 do
                map:添加NPC {
                    名称 = "天龙女",
                    外形 = 2128,
                    等级 = 80,
                    脚本 = 'scripts/npc/大闹天宫/天龙女.lua',
                    X = 起始x + math.random(3),
                    Y = 起始y + math.random(3),
                    行走开关 = true,
                    战斗脚本 = true,
                    行走时间 = os.time() + 2 + i * 2,
                    行走间隔 = 2,
                    路 = n,
                    当前地图 = map,
                    TX = 317,
                    TY = 86,
                    副本 = self
                }
            end
            for i = 1, 1, 1 do
                map:添加NPC {
                    名称 = "多闻天王",
                    外形 = 2126,
                    等级 = 80,
                    脚本 = 'scripts/npc/大闹天宫/多闻天王.lua',
                    X = 起始x + math.random(3),
                    Y = 起始y + math.random(3),
                    行走开关 = true,
                    战斗脚本 = true,
                    行走时间 = os.time() + 2 + i * 2,
                    行走间隔 = 2,
                    路 = n,
                    当前地图 = map,
                    TX = 317,
                    TY = 86,
                    副本 = self
                }
            end
            for i = 1, 1, 1 do
                map:添加NPC {
                    名称 = "哪吒太子",
                    外形 = 2124,
                    等级 = 80,
                    脚本 = 'scripts/npc/大闹天宫/哪吒太子.lua',
                    X = 起始x + math.random(3),
                    Y = 起始y + math.random(3),
                    行走开关 = true,
                    战斗脚本 = true,
                    行走时间 = os.time() + 2 + i * 2,
                    行走间隔 = 2,
                    路 = n,
                    当前地图 = map,
                    TX = 317,
                    TY = 86,
                    副本 = self
                }
            end
        end
    end
end

function 副本:花果山出兵()
    local map = 取地图(101385)
    for n = 1, 3, 1 do
        if self.花果山.箭塔[n] > 0 then
            local 起始x, 起始y = _起始xy2[n][1], _起始xy2[n][2]
            for i = 1, 8, 1 do
                map:添加NPC {
                    名称 = "吉祥果",
                    外形 = 2129,
                    等级 = 80,
                    脚本 = 'scripts/npc/大闹天宫/吉祥果.lua',
                    X = 起始x + math.random(3),
                    Y = 起始y + math.random(3),
                    行走开关 = true,
                    战斗脚本 = true,
                    行走时间 = os.time() + 2 + i * 2,
                    行走间隔 = 2,
                    路 = n,
                    当前地图 = map,
                    TX = 317,
                    TY = 86,
                    副本 = self
                }
            end
            for i = 1, 1, 1 do
                map:添加NPC {
                    名称 = "铁扇仙子",
                    外形 = 2125,
                    等级 = 80,
                    脚本 = 'scripts/npc/大闹天宫/铁扇仙子.lua',
                    X = 起始x + math.random(3),
                    Y = 起始y + math.random(3),
                    行走开关 = true,
                    战斗脚本 = true,
                    行走时间 = os.time() + 2 + i * 2,
                    行走间隔 = 2,
                    路 = n,
                    当前地图 = map,
                    TX = 317,
                    TY = 86,
                    副本 = self
                }
            end
            for i = 1, 1, 1 do
                map:添加NPC {
                    名称 = "混世魔王",
                    外形 = 2127,
                    等级 = 80,
                    脚本 = 'scripts/npc/大闹天宫/混世魔王.lua',
                    X = 起始x + math.random(3),
                    Y = 起始y + math.random(3),
                    行走开关 = true,
                    战斗脚本 = true,
                    行走时间 = os.time() + 2 + i * 2,
                    行走间隔 = 2,
                    路 = n,
                    当前地图 = map,
                    TX = 317,
                    TY = 86,
                    副本 = self
                }
            end
        end
    end
end

function 副本:阵营分配(n)
    local r = 0
    if self.花果山.人数 == self.天庭.人数 then
        r = math.random(2)
    elseif self.花果山.人数 > self.天庭.人数 then
        r = 2
    else
        r = 1
    end
    if r == 1 then
        self.花果山.人数 = self.花果山.人数 + n
    else
        self.天庭.人数 = self.天庭.人数 + n
    end
    return r
end

function 副本:扣除箭塔耐久(数值, 路, 阵营)
    if self[阵营] and self[阵营].箭塔[路] and self[阵营].箭塔[路] > 0 then
        self[阵营].箭塔[路] = self[阵营].箭塔[路] - 数值
        if self[阵营].箭塔[路]<=0 then
            发送系统("#R大闹天宫箭塔摧毁公告")
        end
    end
end

function 副本:取箭塔耐久(阵营, 路)
    if self[阵营] and self[阵营].箭塔[路] then
        return self[阵营].箭塔[路]
    end
    return 0
end

--[[
--夺旗 领任务 夺取对方军旗 夺回军旗 取消任务
--间谍
]]





return 副本
