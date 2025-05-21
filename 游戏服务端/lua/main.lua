if gge.isdebug and os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    package.loaded['lldebugger'] = assert(loadfile(os.getenv('LOCAL_LUA_DEBUGGER_FILEPATH')))()
    require('lldebugger').start()
end

GGF = require('GGE.函数')
require('我的函数')
gge.bitch = '测试' -- 区别区名

local t = os.clock()

-- ====================初始化对象====================
do
    __NPC = setmetatable({}, { __mode = 'v' })
    __物品 = setmetatable({}, { __mode = 'v' })
    __召唤 = setmetatable({}, { __mode = 'v' })
    __孩子 = setmetatable({}, { __mode = 'v' })
    __法宝 = setmetatable({}, { __mode = 'v' })
    __宠物 = setmetatable({}, { __mode = 'v' })
    __坐骑 = setmetatable({}, { __mode = 'v' })
    __怪物 = setmetatable({}, { __mode = 'v' })
    __技能 = setmetatable({}, { __mode = 'v' })
    __内丹 = setmetatable({}, { __mode = 'v' })
    __任务 = setmetatable({}, { __mode = 'v' })
    __副本地图 = setmetatable({}, { __mode = 'v' })
    __地图 = setmetatable({}, { __index = __副本地图 })
    __玩家 = setmetatable(
        {},
        { __mode = 'v', __index = setmetatable({}, { __mode = 'v' }) }
    )
    __对象 = setmetatable(
        {},
        {
            __mode = 'v',
            __index = function(_, k)
                return __物品[k] or __召唤[k] or __宠物[k] or __坐骑[k] or __NPC[k] or __孩子[k] or __法宝[k]
            end
        }
    )

    __垃圾 = {}
    __帮派 = {}
    __事件 = {}
    __脚本 = {}
    __消息列表 = {}

    __机器人 = setmetatable({}, { __mode = 'v' })
    __机器人ID = 1000000 -- 机器人的ID生成

    __config = {
        种族 = 4.1,
        召唤技能 = true,
        -- 在这里拼接ip
        ip = '127.0.0.1',
        port = 9000,           -- 端口号也要换
        redisIp = '127.0.0.1', -- 这里要用本机IP，物理机一般不用改。ECS云服务器要用内网
        redisPort = 6379,      -- 这里端口不用改   6379
        redisDB = 1,           -- 这里如果一台机器上要部署多个， 比如一区是1， 二区就要改成2 三区改成3
        注册开关 = true,
        登录开关 = true,
        服务器开关 = true,
        注册码 = {
            ["8888"] = "8888",
        },
    }
    __redis = require('redis')

    if gge.isdebug then
        __config.ip = '127.0.0.1'
        __config.port = 9000
        __config.新宝石 = true
    end
end

--====================初始化存档====================
do
    __版本 = 1.1
    __存档 = require('数据库/存档')
    __仙玉 = __存档.仙玉
    __等级排行 = __存档.取等级排行榜()
    __财富排行 = __存档.取财富排行榜()
    __帮派排行 = __存档.取帮派排行榜()

    __封禁IP = __redis:获取数据('封禁IP')
    __活动限制 = __redis:获取数据('日常活动限制')
    __周限数据 = __redis:获取数据('周常活动限制')
    __双倍时间 = __redis:获取数据('双倍时间')
    __银两寄售数据 = __redis:获取数据('银两寄售')
    __积分寄售数据 = __redis:获取数据('积分寄售')
    __累计待领取数据 = __redis:获取数据('累计待领取')

    __水陆排行帮 = {
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 127, y = 57, 方向 = 2 },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 123, y = 59, 方向 = 2 },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 119, y = 62, 方向 = 2 },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 115, y = 63, 方向 = 2 },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会冠军", mid = 1003, x = 111, y = 66, 方向 = 2 },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会亚军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
        { 外形 = 1, 名称 = "测试人员", 称谓 = "水陆大会季军" },
    }
end

-- ====================初始化缓存====================
-- do
--     local 所有角色 = __存档.所有角色存档时间()
--     for i, v in ipairs(所有角色) do
--         local data = __redis:读档角色(v.nid)
--         if data and data.存档时间 and data.存档时间 > v.存档时间 then
--             print('恢复角色缓存数据，角色nid:' .. v.nid)
--             __存档.角色存档(data)
--         end
--     end
-- end

-- ====================初始化配置====================
do
    __世界 = require('世界/世界')
    function gge.onerror(err)
        __世界:ERROR(err) -- 错误
    end

    __世界:INFO('读取地图')
    for _, t in ipairs(require('data/map')) do
        local id = t.id
        if id < 100000 and id > 10000 then
            id = id % 10000
        end
        t.障碍 = GGF.读入文件(string.format('data/map/%d.cell', id))
        __地图[t.id] = require('地图/地图')(t)
        if t.id == 101392 then -- 自己不想哪个地图飞 自己id == 那个地图编号就行了-- or t.id == xxx
            __地图[t.id].传送限制 = true
        end
    end


    __世界:INFO('读取脚本')
    __帮战 = require('副本/帮战')()

    __沙盒 = require('沙盒/沙盒')
    require('沙盒/接口')

    __大闹天宫 = require('副本/大闹天宫')()
    __水陆大会 = require('副本/水陆大会')()

    for _, v in pairs(__存档.帮派读取()) do
        require('对象/帮派/帮派')(v)
    end

    __世界:INFO('服务启动')
    __rpc = require('通信/server')
end

-- ====================清空缓存垃圾====================
-- do
--     if next(__垃圾) ~= nil then
--         __世界:INFO('清空缓存垃圾')
--         __世界:清除垃圾()
--     end
-- end


__世界:print('\x1b[32;1m服务启动成功\x1b[0m', os.clock() - t, __版本)


-- 合区
-- t = os.clock()
-- __世界:print('\x1b[32;1m开始合区\x1b[0m')
-- require('数据库/合区')
-- __世界:print('\x1b[32;1m合区完成\x1b[0m', os.clock() - t)

if gge.isdebug then
    require('test')
end
