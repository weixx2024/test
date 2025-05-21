local 事件 = {
   名称 = '为爱逆天',
    类型 = '活动',
    是否打开 = true,
    是否可接任务 = true,
}

function 事件:事件初始化()
    -- 开启时间：周五早8点到晚10点
    if os.date('%w', os.time()) == '3' then
        print('星期三，开启为爱逆天活动')
        local year = tonumber(os.date('%Y', os.time()))
        local month = tonumber(os.date('%m', os.time()))
        local day = tonumber(os.date('%d', os.time()))
        self.开始时间 = os.time { year = year, month = month, day = day, hour = 08, min = 00, sec = 00 }
        self.结束时间 = os.time { year = year, month = month, day = day, hour = 22, min = 00, sec = 00 }
        self.是否结束 = false
    end
end

local _主怪信息 = {
    { 名称 = '奎木狼', 脚本 = 'scripts/npc/限时活动/为爱逆天/奎木狼.lua', 外形 = 42, 地图 = 1193, X = 157, Y = 132, 方向 = 1 },
    { 名称 = '水德星君', 脚本 = 'scripts/npc/限时活动/为爱逆天/水德星君.lua', 外形 = 44, 地图 = 1194, X = 497, Y = 20, 方向 = 1 },
    { 名称 = '火德星君', 脚本 = 'scripts/npc/限时活动/为爱逆天/火德星君.lua', 外形 = 54, 地图 = 1110, X = 438, Y = 63, 方向 = 1 },
    { 名称 = '天王李靖', 脚本 = 'scripts/npc/限时活动/为爱逆天/天王李靖.lua', 外形 = 2122, 地图 = 1236, X = 181, Y = 125, 方向 = 1 },
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
            称谓 = '为爱逆天',
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
    print('为爱逆天活动开始')
end

function 事件:事件结束()
    self.是否结束 = true
    self:清除所有怪物()
    print('为爱逆天活动结束')
end

return 事件
