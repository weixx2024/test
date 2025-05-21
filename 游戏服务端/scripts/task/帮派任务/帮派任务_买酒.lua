-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-09-07 15:17:32

local 任务 = {
    名称 = '帮派任务_买酒',
    别名 = '帮派任务',
    类型 = '日常任务'
}

function 任务:任务初始化(玩家, ...)
end

local _酒店列表 = {
    [1001] = { 1028, 1027, 1030 },
    [1236] = { 1246, 1272, 1278, 1286 },
    [1070] = { 1075 },
    [1092] = { 1097 },

}
local _随机地图 = { 1001, 1236, 1070, 1092 }


local _描述 = '去长安,洛阳,傲来,长寿的#G酒店老板#W打听一下价格。#W(当前第#R%s#W次，剩余#R%d#W分钟)'
function 任务:任务取详情(玩家)
    if self.时间 then
        return string.format(_描述, self.环数, (self.时间 - os.time()) // 60)
    end
end

function 任务:任务取消(玩家)
    玩家.其它.帮派环数 = nil
end

function 任务:任务更新(sec, 玩家)
    if self.时间 - os.time() <= 0 then
        玩家.其它.帮派环数 = nil
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if self.时间 - os.time() <= 0 then
        玩家.其它.帮派环数 = nil
        self:删除()
    end
end

function 任务:任务下线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
        玩家.其它.帮派环数 = nil
    end
end

function 任务:添加任务(玩家)
    self.map = _随机地图[math.random(#_随机地图)]
    self.时间 = os.time() + 1800
    if 玩家:添加物品({ 生成物品 { 名称 = '订单', 数量 = 1 } }) then
        玩家.其它.帮派环数 = 玩家.其它.帮派环数 + 1
        if 玩家.其它.帮派环数 > 10 then
            玩家.其它.帮派环数 = 1
        end
        self.环数 = 玩家.其它.帮派环数
        玩家:添加任务(self)
        self.最后对话 = "#W最近帮里要订一批酒,你去长安,洛阳,傲来,长寿的#G酒店老板#W打听一下价格去。"
        return true
    else
        self.最后对话 = "你身上装不下我要给你的订单。"
    end
end

local _掉落 = {
    总几率 = 1000,
    空车率 = 700,
    { 几率 = 3, 名称 = '补天神石', 数量 = 1, 广播 = '#C%s在帮派任务中获得了#G#m(%s)[%s]#m#n' },
    { 几率 = 5, 名称 = '盘古精铁', 数量 = 1, 广播 = '#C%s在帮派任务中获得了#G#m(%s)[%s]#m#n' },
    { 几率 = 7, 名称 = '天外飞石', 数量 = 1, 广播 = '#C%s在帮派任务中获得了#G#m(%s)[%s]#m#n' },
    { 几率 = 9, 名称 = '千年寒铁', 数量 = 1, 广播 = '#C%s在帮派任务中获得了#G#m(%s)[%s]#m#n' },
}
function 任务:掉落几率_初始化()
    self.总几率 = _掉落.总几率
    self.空车率 = _掉落.空车率
    self.几率 = 0
    for i, v in ipairs(_掉落) do
        self.几率 = self.几率 + v.几率
    end
end

function 任务:掉落包(玩家) --1寻药
    local 经验 = math.floor(59884 * (1 + self.环数 * 0.35)) --1154万经验
    local 银子 = math.floor(1000 * (1 + self.环数 * 0.36)) --产出197400银两
    local 成就 = math.floor(40 * (1 + self.环数 * 0.2)) --满次获得2460成就
    玩家:添加任务经验(经验, "帮派")
    玩家:添加银子(银子, "帮派")
    玩家:添加参战召唤兽亲密度(300, "帮派")
    玩家:添加帮派成就(成就)
    玩家:添加帮派建设度(11000000)

    -- 玩家:增加活动限制次数('帮派任务')

    if math.random(self.总几率) > self.空车率 then
        local 总几率 = math.random(self.几率)
        local 几率 = 0
        for i, v in ipairs(_掉落) do
            几率 = 几率 + v.几率
            if 总几率 <= 几率 then
                local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数, 禁止交易 = v.禁止交易 }
                if r then
                    玩家:添加物品({ r })
                    if v.广播 then
                        玩家:发送系统(v.广播, 玩家.名称, r.nid, r.名称)
                    end
                    break
                end
            end
        end
    end
    self:删除()
end

--==================================================
local 对话 = [[最近生意好差，酒价都降了几次了都卖不出去,如果你们帮要可以优惠些给你
menu
15|给他订单
99|离开
]]

local 对话2 = [[最近生意很好，酒的价格有点高，嫌贵的可以去别家看看。
menu
]]


local 对话3 = [[我是帮派总管,帮中事物无论大小都经由我处理。
menu
25|我来取消帮派任务
99|离开
]]
function 任务:地图核对(玩家)
    local t = _酒店列表[self.map]
    local map = 玩家:取当前地图()
    for i, v in ipairs(t) do
        if map.id == v then
            return true
        end
    end
end

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == "酒店老板" then
        if self:地图核对(玩家) then
            NPC.台词 = 对话
            return
        end
        NPC.台词 = 对话2
    elseif NPC.名称 == "帮派总管" then
        NPC.台词 = 对话3
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == "酒店老板" then
        if i == "15" then
            if self:地图核对(玩家) then
                local r = 玩家:取物品是否存在("订单")
                if r then
                    r:减少(1)
                    self:掉落包(玩家)
                    NPC.台词 = '你的订单我收下了,马上给你们送过去！'
                else
                    NPC.台词 = '我要的东西呢！'
                end
            end
        end
    elseif NPC.名称 == "帮派总管" then
        if i == "25" then
            local r = 玩家:取任务('帮派任务_买酒')
            if r then
                r:任务取消(玩家)
                r:删除(玩家)
            end
        end
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if NPC.名称 == "酒店老板" then
        local r = 玩家:取任务("帮派任务_买酒")
        if r then
            if self:地图核对(玩家) then
                if items[1].名称 == "订单" then
                    if items[1].数量 >= 1 then
                        items[1]:接受(1)
                        r:掉落包(玩家)
                        NPC.台词 = '你的订单我收下了,马上给你们送过去！'
                    end
                end
            end
        end
    end
end

return 任务
