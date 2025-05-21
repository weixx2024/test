-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-09-07 15:17:32

local 任务 = {
    名称 = '帮派任务_讨债',
    别名 = '帮派任务',
    类型 = '日常任务'
}

function 任务:任务初始化(玩家, ...)
end

local _描述 = '长寿#G#u#[1077|14|7|$药店老板#]#u#W欠我们帮的银子还没有还,你去顺便要一下。。#W(当前第#R%s#W次，剩余#R%d#W分钟)'
function 任务:任务取详情(玩家)
    if self.时间 then
        if not self.银票 then
            return string.format(_描述, self.环数,
                (self.时间 - os.time()) // 60)
        else
            return string.format("要到银票,把银票交给帮派总管。#W(当前第#R%s#W次，剩余#R%d#W分钟)", self.环数,
                (self.时间 - os.time()) // 60)
        end
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
    玩家.其它.帮派环数 = 玩家.其它.帮派环数 + 1
    if 玩家.其它.帮派环数 > 10 then
        玩家.其它.帮派环数 = 1
    end
    self.环数 = 玩家.其它.帮派环数
    self.时间 = os.time() + 1800
    玩家:添加任务(self)
    self.最后对话 = "#W长寿药店老板欠我们帮的银子还没有还,找#Y长寿村#W的#G药店老板#W收取银票"
    return true
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
local 对话 = [[这里是长寿药店，大侠需要点什么呢？
menu
15|我来要账
99|取消
]]

local 对话2 = [[我是帮派总管,帮中事物无论大小都经由我处理。
menu
16|我来交任务
26|我来取消帮派任务
99|离开
]]



function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == "药店老板" and NPC.mid == 1077 then
        NPC.台词 = 对话
    elseif NPC.名称 == "帮派总管" then
        NPC.台词 = 对话2
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == "药店老板" and NPC.mid == 1077 then
        if i == "15" then
            if not self.银票 then
                if 玩家:添加物品({ 生成物品 { 名称 = '银票', 任务物品 = true, 禁止交易 = true, 数量 = 1 } }) then
                    NPC.台词 = "银子早给你准备好了,这是你的银票"
                    NPC.结束 = true
                    self.银票 = true
                else
                    NPC.台词 = "你身上可装不下我给你的银票哦"
                end
            else
                NPC.台词 = "快把银票交给帮派总管吧！"
            end
        end
    elseif NPC.名称 == "帮派总管" then
        if i == "16" then
            local r = 玩家:取物品是否存在("银票")
            if r then
                r:减少(1)
                self:掉落包(玩家)
                NPC.台词 = '做的不错,给你奖励！'
            else
                NPC.台词 = '你要的账呢#24'
            end
        elseif i == "26" then
            local r = 玩家:取任务('帮派任务_讨债')
            if r then
                r:任务取消(玩家)
                r:删除(玩家)
            end
        end
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if NPC.名称 == "帮派总管" then
        local r = 玩家:取任务("帮派任务_讨债")
        if r and r.银票 then
            if items[1].名称 == "银票" then
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    r:掉落包(玩家)
                    NPC.台词 = '做的不错,给你奖励！'
                end
            end
        end
    end
end

return 任务
