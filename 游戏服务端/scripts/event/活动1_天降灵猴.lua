local 事件 = {
    名称 = '天降灵猴',
    类型 = '活动',
    是否打开 = true,
    是否可接任务 = true,
}

function 事件:事件初始化()
    -- if os.date('%w', os.time()) == '1' then
    --     print('星期一，开启天降灵猴')
    --     local year = tonumber(os.date('%Y', os.time()))
    --     local month = tonumber(os.date('%m', os.time()))
    --     local day = tonumber(os.date('%d', os.time()))
    --     self.开始时间 = os.time { year = year, month = month, day = day, hour = 08, min = 00, sec = 00 }
    --     self.结束时间 = os.time { year = year, month = month, day = day, hour = 22, min = 00, sec = 00 }
    --     self.是否结束 = false
    -- end
end

local _主怪信息 = {
    [1] = { 名称 = '灵猴', 模型 = 2514, 数量 = 200 },
}

local _地图 = { 1001, 1236, 1110, 1173 }

function 事件:取怪物数量(地图, 名称)
    local 数量 = 0
    local map = self:取地图(地图)
    for k, v in map:遍历NPC() do
        if v.名称 == 名称 then
            数量 = 数量 + 1
        end
    end
    return 数量
end

function 事件:清除所有怪物()
    for ii, vv in ipairs(_地图) do
        local map = self:取地图(vv)
        for i = 1, #_主怪信息 do
            for k, v in map:遍历NPC() do
                if v.名称 == _主怪信息[i].名称 then
                    v:删除()
                end
            end
        end
    end
end

function 事件:更新()
    if self.是否结束 then
        return
    end
    local 地图组 = {}
    self.时间 = os.time() + 30 * 60
    for ii, vv in ipairs(_地图) do
        local map = self:取地图(vv)
        table.insert(地图组, map.名称)
        for i = 1, #_主怪信息 do
            -- 先清空
            for k, v in map:遍历NPC() do
                if v.名称 == _主怪信息[i].名称 and not v.战斗中 then
                    v:删除()
                end
            end

            local 刷新数量 = _主怪信息[i].数量
            for _ = 1, 刷新数量 do
                local 方向 = math.random(1, 4)
                local X, Y = map:取随机坐标()
                local NPC = map:添加NPC {
                    名称 = _主怪信息[i].名称,
                    外形 = _主怪信息[i].模型,
                    称谓 = '天降灵猴',
                    方向 = 方向,
                    脚本 = 'scripts/event/活动1_天降灵猴.lua',
                    时间 = self.时间,
                    X = X,
                    Y = Y,
                    来源 = self
                }
            end
        end
    end
    self:发送系统('#C押运贪官镖银的车队正在路过#Y%s，#G请各位有志之士火速前往，夺取镖银。#90', table.concat(地图组, '、'))
    return 1800
end

function 事件:事件开始()
    self:更新()
    self:定时(1800, self.更新)
    print('天降灵猴活动开始')
end

function 事件:事件结束()
    self.是否结束 = true
    self:清除所有怪物()
    print('天降灵猴活动结束')
end

--=======================================================
local 对话 = [[
灵猴一闪，盆盈钵满！
menu
1|抢的就是你，打劫！
2|我认错人了
]]

function 事件:NPC对话(玩家, NPC)
    if 玩家:取活动限制次数('天降灵猴') >= 25 then
        return '当天任务已达上限！'
    end

    if 玩家.是否组队 then
        return '该任务无法组队进行！'
    end
    if 玩家:取队伍人数() > 1 then
        return '该任务无法组队进行！'
    end

    return 对话
end

function 事件:NPC菜单(玩家, i, NPC)
    if NPC and NPC:是否战斗中() then
        return "我正在战斗中"
    end
    if i == '1' then
        if not NPC:是否战斗中() then
            NPC:进入战斗(true)
            local r = 玩家:进入战斗('scripts/event/活动1_天降灵猴.lua', NPC)
            NPC:删除()
            NPC:进入战斗(false)
        else
            return "我正在战斗中"
        end
    end
end

function 事件:战斗初始化(玩家)
    local 怪物属性
    怪物属性 = {
        名称 = "灵猴",
        外形 = 2514,
        等级 = 1,
        气血 = 1,
        魔法 = 1,
        攻击 = 1,
        速度 = -9999,
        抗性 = {
            抗混乱 = 999,
            抗昏睡 = 999,
            抗封印 = 999,
        },
        技能 = { { 名称 = '天降灵猴', 类别 = '怪物' } },
        施法几率 = 0,
        是否消失 = false,
    }
    self:加入敌方(1, 生成战斗怪物(怪物属性))
end

function 事件:战斗回合开始(对象)
    对象.指令 = '物理'
    对象.目标 = 1

    local 灵猴 = self:取对象(101)
    if 灵猴 then
        local buff = 灵猴:取BUFF('天降灵猴')
        if buff.银子 > 1000000 then -- 大于100w必跑
            对象.指令 = '逃跑'
            return
        end

        local 概率 = (self.回合数 % 10) * 6

        if self.回合数 > 10 then
            概率 = 90
        end

        if math.random(100) < 概率 then
            对象.指令 = '逃跑'
        end
    end
end

function 事件:战斗结束(胜负)
    if 胜负 then
        local 灵猴 = self:取对象(101)
        if 灵猴 then
            local buff = 灵猴:取BUFF('天降灵猴')
            for _, v in self:遍历我方() do
                if v.是否玩家 then
                    事件:掉落包(v, buff.银子)
                end
            end
        end
    end
end

local _广播 = "#C不得了啊，#Y%s#C身手敏捷，一把抓住#G灵猴#C的尾巴：“小样还想跑？先把钱留下！”硬是从灵猴身上抢回了%s两银子"

function 事件:掉落包(玩家, 银子)
    if 玩家.接口:取活动限制次数('天降灵猴') >= 25 then
        return
    end
    玩家.接口:增加活动限制次数('天降灵猴')

    if 银子 > 0 then
        local 双倍银子 = math.ceil(银子 * 2)
        玩家.接口:添加银子(双倍银子, '天降灵猴')
        玩家.接口:发送系统(_广播, 玩家.名称, 双倍银子)
        玩家.接口:最后对话(string.format('和你开个小小的玩笑而已，何必动怒，这份礼物送你，你得到了#R%s#W两银子。', 双倍银子))
    end

    -- local 经验 = 350000
    -- 玩家:添加经验(经验)
    -- 玩家:添加参战召唤兽经验(经验 * 1.5)

    -- local 掉落包 = 取掉落包('活动', '天降灵猴')
    -- if 掉落包 then
    --     奖励掉落包物品(玩家, 掉落包)
    -- end
end

return 事件
