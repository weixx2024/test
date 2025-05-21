-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2023-06-23 21:12:53

local 任务 = {
    名称 = '帮派任务_除草',
    别名 = '帮派任务',
    类型 = '日常任务'
}

function 任务:任务初始化(玩家, ...)
    self.进度 = 1
end

local _描述 = '帮里很久没有清理杂草了,我给你一把锄头,你到帮里#G%s#W附近清理一下杂草。#W(当前第#R%s#W次，剩余#R%d#W分钟)'
function 任务:任务取详情(玩家)
    if self.位置 and self.时间 then
        if not self.除草 then
            return string.format(_描述, self.位置, self.环数, (self.时间 - os.time()) // 60)
        else
            return "恭喜你！杂货已经清理干净了，去找帮派主管复命吧。"
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

function 任务:添加任务(玩家) --1寻药
    local map = 玩家:取帮派地图()
    if not map then
        return
    end
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.时间 = os.time() + 1800
    self.位置 = string.format('(%d,%d)', X, Y)
    self.x, self.y = X, Y
    self.mapid = map.id
    if 玩家:添加物品({ 生成物品 { 名称 = '锄头', 坐标 = self.位置, 数量 = 1 } }) then
        玩家.其它.帮派环数 = 玩家.其它.帮派环数 + 1
        if 玩家.其它.帮派环数 > 10 then
            玩家.其它.帮派环数 = 1
        end
        self.环数 = 玩家.其它.帮派环数
        玩家:添加任务(self)
        self.进度 = 1
        self.除草 = false
        self.最后对话 = "帮里很久没有清理杂草了,我给你一把锄头,你到帮里清理一下杂草。"
        return true
    else
        self.最后对话 = "你身上装不下我要给你的锄头。"
    end
end

function 任务:开始除草(玩家)
    local map = 玩家:取当前地图()
    if not map then
        return "#Y未知地图"
    end
    if map.id ~= self.mapid then
        return "#Y这里不是帮派里哦！"
    end
    if math.abs(self.x - 玩家.X) < 5 and math.abs(self.y - 玩家.Y) < 5 then
        self.进度 = self.进度 + 1
        if math.random(3, 5) <= self.进度 then
            self.除草 = true
            玩家:最后对话("恭喜你！杂草已经清理干净了，去找帮派主管复命吧。")
            return true
        end
        local X, Y = map:取随机坐标()
        if not X then
            return
        end
        self.x, self.y = X, Y
        self.位置 = string.format('(%d,%d)', X, Y)
        玩家:最后对话("经过你的不懈努力，帮派里的杂草似乎变少了")
        return
    else
        玩家:最后对话("此处已经没有杂草了,去别去去看看")
        return
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
    local 成就 = 0


    local h = 0
    for i = 1, 15, 1 do
        h = h + 1
        if h > 10 then
            h = 1
        end
        成就 = 成就 + math.floor(50 * (1 + h * 0.2))
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

local 对话 = [[我是帮派总管,帮中事物无论大小都经由我处理。
menu
11|我来交任务
21|我来取消帮派任务
99|离开
]]
function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == "帮派总管" then
        NPC.台词 = 对话
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == "帮派总管" then
        if i == "11" then
            if self.除草 then --
                self:掉落包(玩家)
                NPC.台词 = '做的不错,给你奖励！'
            else
                NPC.台词 = "帮里很久没有清理杂草了,我给你一把锄头,你到帮里清理一下杂草。"
            end
        elseif i == "21" then
            local r = 玩家:取任务('帮派任务_除草')
            if r then
                r:任务取消(玩家)
                r:删除(玩家)
            end
        end
    end
end

return 任务
