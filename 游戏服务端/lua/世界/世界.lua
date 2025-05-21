__时辰 = 1
local 世界 = require('GOL')("GAME")
local GGF = require('GGE.函数')
引擎 = 世界
--'逻辑服务'
function 世界:初始化()
    self.rpc =
        setmetatable(
            {},
            {
                __index = function(_, k)
                    return function(_, ...)
                        local arg = { ... }
                        local list = {}
                        for k, v in self:遍历玩家() do
                            if not v.是否掉线 then
                                list[k] = v
                            end
                        end
                        coroutine.xpcall(
                            function()
                                local n = 0
                                for _, v in pairs(list) do
                                    v.rpc[k](nil, table.unpack(arg))
                                    n = n + 1
                                    if n % 50 == 0 then --发送50个玩家，停一下
                                        self:定时(100)
                                    end
                                end
                            end
                        )
                    end
                end
            }
        )

    self._定时按秒 = self:定时( --按秒
        1000,
        function(ms)
            if not __rpc then
                return
            end
            self:更新按秒(os.time())
            return ms
        end
    )

    self._定时按分 = self:定时(
        60 * 1000,
        function(ms)
            if not __rpc then
                return
            end
            self:更新按分(os.time())
            return ms
        end
    )

    self._定时按时 = self:定时( --60分钟
        60 * 60 * 1000, --5*60*1000
        function(ms)
            self:更新按时(os.time())

            return ms
        end
    )

    -- self.玩家 = getmetatable(__玩家).__index --名称索引
end

function 世界:更新按秒(sec)
    local t = os.clock()
    local MM = os.date('%M', sec)
    local SS = os.date('%S', sec)

    for i, v in pairs(__玩家) do
        v:更新(sec)
    end

    for _, v in pairs(__地图) do
        v:更新(sec)
    end

    -- todo 帮派开发
    -- for _, v in pairs(__帮派) do
    --     v:更新(sec)
    -- end
    -- print(string.format('更新耗时 %.4f', os.clock() - t))

    for k, v in pairs(__事件) do
        if v.是否打开 and v.开始时间 and v.结束时间 then
            if sec > v.结束时间 then
                if v._是否开始 then
                    v._是否开始 = false
                    ggexpcall(v.事件结束, v)
                end
            elseif not v._是否开始 and sec > v.开始时间 then
                v._是否开始 = true
                ggexpcall(v.事件开始, v)
            end
        end
    end

    __水陆大会:更新(sec)

    if SS == '00' then
        self:整分处理(sec)
    end

    if MM == '00' and SS == '00' then
        self:整点处理(sec)
    end

    if self.关闭倒计时 then
        self:关闭处理()
    end
end

function 世界:更新按分(sec)
    -- local 垃圾数据 = {}
    -- for k, v in pairs(__垃圾) do
    --     if v.rid == -1 then
    --         垃圾数据[k] = { 表名 = ggetype(v), nid = v.nid }
    --     end
    -- end
    -- __redis:存档数据('垃圾表', 垃圾数据)
end

function 世界:更新按时(sec)
    -- todo 帮战未做
    __redis:存档数据('日常活动限制', __活动限制)
    __redis:存档数据('周常活动限制', __周限数据)
    __redis:存档数据('封禁IP', __封禁IP)
    __redis:存档数据('银两寄售', __银两寄售数据)
    __redis:存档数据('积分寄售', __积分寄售数据)
    __redis:存档数据('累计待领取', __累计待领取数据)
    __帮战:存档()

    local list = {}
    for _, v in pairs(__帮派) do
        list[v.nid] = v:取存档数据()
    end
    __存档.帮派写入(list)

    self:清除垃圾()
    __存档.写仙玉()
end

function 世界:整分处理(sec)
    local HH = os.date('%H', sec)
    local MM = os.date('%M', sec)
    local SS = os.date('%S', sec)

    __帮战:整分处理(sec)
    __水陆大会:整分处理(sec)
end

function 世界:整点处理(sec)
    local HH = os.date('%H', sec)
    local MM = os.date('%M', sec)
    local SS = os.date('%S', sec)
    local Week = os.date('%w', sec)

    __等级排行 = __存档.取等级排行榜()
    __财富排行 = __存档.取财富排行榜()
    __帮派排行 = __存档.取帮派排行榜()

    __帮战:整点处理(sec)
    __水陆大会:整点处理(sec)

    -- 重置每日 0点
    if HH == '00' and MM == '00' and SS == '00' then
        世界:print('重置每日数据')
        __活动限制 = {}
        __五倍时间 = {}
        for _, v in pairs(__帮派) do
            v:帮派维护()
        end
        for k, v in pairs(__事件) do
            if v.是否打开 then
                ggexpcall(v.事件初始化, v)
            end
        end
        __地图在线奖励 = GGF.复制表(__脚本['scripts/make/地图在线奖励.lua'])
    end

    -- 重置每周 周一 0点
    if Week == "1" and HH == '00' and MM == '00' and SS == '00' then
        世界:print('重置每周数据')
        __双倍时间 = {}
        __周限数据 = {}
    end
end

function 世界:重置日常()
    __活动限制 = {}
    for k, v in pairs(__事件) do
        if v.是否打开 then
            ggexpcall(v.事件初始化, v)
        end
    end
end

function 世界:重置双倍()
    __双倍时间 = {}
end

function 世界:关闭处理()
    if self.关闭倒计时 then
        self.关闭倒计时 = self.关闭倒计时 - 1
        if self.关闭倒计时 == 120 then
            self:发送公告("#R服务器将在2分钟后进行维护！请各位玩家立即下线！#46")
        elseif self.关闭倒计时 == 60 then
            self:发送公告("#R服务器将在1分钟后进行维护！请各位玩家立即下线！#46")
        end
        if self.关闭倒计时 < 20 then
            self:发送系统("#R服务器将在%s秒后进行维护！请各位玩家立即下线！#46", self.关闭倒计时)
        end
        if self.关闭倒计时 <= 0 then
            self:所有玩家下线()
            self:保存数据()
            self.关闭倒计时 = nil
        end
    end
end

function 世界:保存数据()
    世界:print('存档开始', os.date())
    for _, v in pairs(__玩家) do
        -- v:存档()
        v:踢下线()
    end

    self:清除垃圾()
    __存档.写仙玉()

    local list = {}
    for _, v in pairs(__帮派) do
        list[v.nid] = v:取存档数据()
    end
    __存档.帮派写入(list)
    __帮战:存档()

    __redis:存档数据('五倍时间', __五倍时间)
    __redis:存档数据('双倍时间', __双倍时间)
    __redis:存档数据('日常活动限制', __活动限制)
    __redis:存档数据('周常活动限制', __周限数据)
    __redis:存档数据('封禁IP', __封禁IP)
    __redis:存档数据('银两寄售', __银两寄售数据)
    __redis:存档数据('积分寄售', __积分寄售数据)
    __redis:存档数据('累计待领取', __累计待领取数据)

    世界:print('存档完成', os.date())
end


function 世界:清除垃圾()
    local list = {}
    for k, v in pairs(__垃圾) do
        if v.rid == -1 then
            list[k] = { 表名 = ggetype(v), nid = v.nid }
        end
    end
    __垃圾 = {}
    __存档.删除垃圾(list)
    -- __redis:存档数据('垃圾表', {})
end

function 世界:所有玩家下线(sec)
    coroutine.xpcall(
        function()
            local n = 0
            for _, v in pairs(__玩家) do
                if v.管理 == 0 then
                    n = n + 1
                    v:踢下线()
                    if n % 5 == 0 then --踢5个玩家，停一下，
                        self:定时(100)
                    end
                end
            end
        end
    )
end

function 世界:关闭服务器()
    self:清除垃圾()
    __存档.写仙玉()

    self:发送公告("#R服务器将在3分钟后进行维护！请各位玩家立即下线！#46")
    self.关闭倒计时 = 180
    __config.服务器开关 = false
end

function 世界:添加玩家(P) --从数据新建玩家，但并没有链接
    if not __玩家[P.nid] then
        -- self.玩家[P.名称] = P
        -- self.玩家[P.id] = P
        __玩家[P.nid] = P

        if not P.是否机器人 then
            self:INFO('世界添加玩家:%s 登录ip:%s', P.名称, P.ip)
        else
            __机器人[P.nid] = P
        end
    end
    return P
end

function 世界:删除玩家(P)
    if __玩家[P.nid] then
        -- self.玩家[P.名称] = nil
        -- self.玩家[P.id] = nil
        __玩家[P.nid] = nil
        if P.是否机器人 then
            __机器人[P.nid] = nil
        else
            self:INFO('世界删除玩家:%s(%s)', P.名称, P.ip)
        end
    end
end

function 世界:遍历玩家()
    return next, __玩家
end

function 世界:遍历银子寄售()
    return next, __银两寄售数据
end

function 世界:遍历积分寄售()
    return next, __积分寄售数据
end

function 世界:遍历帮派()
    return next, __帮派
end

function 世界:取随机玩家(nid) --范围nid
    local list = {}
    local n = 0
    for _, v in pairs(__玩家) do
        if v:符合替身(nid) then
            table.insert(list, v.nid)
            n = n + 1
            if n > 20 then
                break
            end
        end
    end
    if n > 0 then
        return list[math.random(n)]
    end
end

function 世界:取玩家总数()
    local n = 0
    local d = 0
    local bt = 0
    local wz = 0
    for _, v in self:遍历玩家() do
        if not v.是否机器人 then
            n = n + 1
        end
        if not v.是否掉线 then
        else
            d = d + 1
            if v.是否摆摊 then
                bt = bt + 1
            else
                wz = wz + 1
            end
        end
    end
    return n, d, bt, wz
end

function 世界:是否白天()
    return __时辰 >= 5 and __时辰 <= 10
end

function 世界:发送世界(str, ...)
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.rpc:界面信息_聊天('#69 ' .. str)
end

function 世界:发送系统(str, ...)
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.rpc:界面信息_聊天('#71 ' .. str)
end

function 世界:发送信息(str, ...)
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.rpc:界面信息_聊天('#114 ' .. str)
end

function 世界:发送公告(str, ...)
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.rpc:界面信息_公告(str)
end

世界:初始化()

return 世界
