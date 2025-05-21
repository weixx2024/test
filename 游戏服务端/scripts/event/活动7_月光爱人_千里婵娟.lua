local 事件 = {
    名称 = '千里婵娟',
    是否打开 = true,
}

function 事件:事件初始化()
   -- 开启时间：周日早8点到晚10点
   -- if os.date('%w', os.time()) == '7' then
   --     print('星期天，开启千里婵娟活动')
   --     local year = tonumber(os.date('%Y', os.time()))
   --     local month = tonumber(os.date('%m', os.time()))
   --     local day = tonumber(os.date('%d', os.time()))
   --     self.开始时间 = os.time { year = year, month = month, day = day, hour = 08, min = 00, sec = 00 }
   --     self.结束时间 = os.time { year = year, month = month, day = day, hour = 22, min = 00, sec = 00 }
   --     self.是否结束 = false
    -- end
end

local _主怪信息 = {
    { 名称 = '婵娟', 脚本 = 'scripts/npc/限时活动/千里婵娟/婵娟.lua', 外形 = 2455, 地图 = 1001, X = 266, Y = 112, 方向 = 1 },
    { 名称 = '红拂女', 脚本 = 'scripts/npc/限时活动/千里婵娟/红拂女.lua', 外形 = 51, 地图 = 1110, X = 233, Y = 134, 方向 = 1 },
    { 名称 = '狐美人', 脚本 = 'scripts/npc/限时活动/千里婵娟/狐美人.lua', 外形 = 10, 地图 = 1193, X = 79, Y = 86, 方向 = 1 },
    { 名称 = '虎头怪', 脚本 = 'scripts/npc/限时活动/千里婵娟/虎头怪.lua', 外形 = 9, 地图 = 1194, X = 371, Y = 75, 方向 = 1 },
    { 名称 = '龙战将', 脚本 = 'scripts/npc/限时活动/千里婵娟/龙战将.lua', 外形 = 14, 地图 = 1173, X = 594, Y = 51, 方向 = 1 },
    { 名称 = '燕山雪', 脚本 = 'scripts/npc/限时活动/千里婵娟/燕山雪.lua', 外形 = 41, 地图 = 1203, X = 40, Y = 86, 方向 = 1 },
    { 名称 = '剑侠客', 脚本 = 'scripts/npc/限时活动/千里婵娟/剑侠客.lua', 外形 = 2, 地图 = 1092, X = 163, Y = 114, 方向 = 1 },
}

function 事件:清除所有怪物()
    for i = 1, #_主怪信息 do
        local map = self:取地图(_主怪信息[i].地图)
        for k, v in map:遍历NPC() do
            if v.名称 == _主怪信息[i].名称 then
                v:删除()
            end
        end
    end
end

function 事件:更新()
    self:清除所有怪物()
    for k, v in pairs(_主怪信息) do
        local map = self:取地图(v.地图)
        local NPC = map:添加NPC {
            名称 = v.名称,
            外形 = v.外形,
            称谓 = '千里婵娟',
            方向 = v.方向,
            脚本 = v.脚本,
            X = v.X,
            Y = v.Y,
            来源 = self
        }
    end
end

function 事件:事件开始()
    self:更新()
    print('千里婵娟活动开始')
end

function 事件:事件结束()
    self.是否结束 = true
    self:清除所有怪物()
    print('千里婵娟活动结束')
end

return 事件
