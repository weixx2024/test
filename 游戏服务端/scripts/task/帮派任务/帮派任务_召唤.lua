-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-09-07 15:17:32

local 任务 = {
    名称 = '帮派任务_召唤',
    别名 = '帮派任务',
    类型 = '日常任务'
}

function 任务:任务初始化(玩家, ...)
    self.进度 = 1
end

local _描述 = '#W帮里需要一批看门的召唤兽,你去给我抓一只来！去#G%s#W抓一只%s。#W(当前第#R%s#W次，剩余#R%d#W分钟)'
function 任务:任务取详情(玩家)
    if self.时间 then
        return string.format(_描述, self.位置, self.召唤, self.环数,
            (self.时间 - os.time()) // 60)
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

local _召唤列表 = {
    { "大雁塔", "夜叉" },
    { "大雁塔", "牛妖" },
    { "大雁塔", "小妖" },
    { "大雁塔", "羊头怪" },
    { "大雁塔", "兔妖" },
    { "大雁塔", "猪怪" },

}



function 任务:添加任务(玩家) --1寻药
    玩家.其它.帮派环数 = 玩家.其它.帮派环数 + 1
    if 玩家.其它.帮派环数>10 then
        玩家.其它.帮派环数=1
    end
    self.环数 = 玩家.其它.帮派环数
    self.时间 = os.time() + 1800
    local t = _召唤列表[math.random(#_召唤列表)]
    self.位置 = t[1]
    self.召唤 = t[2]
    玩家:添加任务(self)
    self.最后对话 = '#W帮里需要一批看门的召唤兽,你去给我抓一只来！'
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
    local 经验 = math.floor( 59884 * (1 + self.环数 * 0.35) ) --1154万经验
    local 银子 = math.floor( 1000 * (1 + self.环数 * 0.36) )          --产出197400银两
    local 成就 = math.floor( 40 * (1 + self.环数 * 0.2)  )       --满次获得2460成就
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
12|我来交任务
22|我来取消帮派任务
99|离开
]]
function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == "帮派总管" then
        self.召唤列表 = {}
        NPC.台词 = 对话
    end
end

function 任务:取提交对话(玩家, t)
    local r = "你要上交哪一只召唤兽呢？\nmenu\n"
    local list = {}
    for i, v in ipairs(t) do
        table.insert(list, string.format("%s|%s转%s级%s", 100 + i, v.转生, v.等级, v.名称))
    end
    r = r .. table.concat(list, "\n")
    return r
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == "帮派总管" then
        if i == "12" then
            self.召唤列表 = 玩家:取召唤兽_按原名(self.召唤) --(self.召唤)
            if not next(self.召唤列表) then
                NPC.台词 = "你身上没有我要的召唤兽哦！"
                return
            end
            NPC.台词 = self:取提交对话(玩家, self.召唤列表)
            NPC.结束 = false
        elseif i == "22" then
            local r = 玩家:取任务('帮派任务_召唤')
            if r then
                r:任务取消(玩家)
                r:删除(玩家)
            end
        else
            if i then
                local ii = tonumber(i)
                if ii > 100 then
                    local t = 玩家:取召唤兽_按原名(self.召唤)
                    local n = i - 100
                    if t[n] and self.召唤列表[n] and t[n].nid == self.召唤列表[n].nid then

                        local r = 玩家:取召唤兽_按nid(t[n].nid)
                        if r then
                            local v = r:丢弃()
                            if type(v)=="string" then
                                NPC.台词 = v
                            elseif  v==true then
                                self:掉落包(玩家)
                                NPC.台词 = '做的不错,给你奖励！'
                            end
                        else
                            NPC.台词 = "该召唤兽不存在！"
                        end

                    else
                        NPC.台词 = "你身上的召唤列表发生变化，请重新打开对话！"
                    end
                end
            end
        end
    end








end

return 任务
