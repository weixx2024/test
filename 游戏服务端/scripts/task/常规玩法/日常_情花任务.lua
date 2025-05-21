-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-06-04 19:44:01
-- @Last Modified time  : 2023-08-25 21:36:33

local 任务 = {
    名称 = '日常_情花任务',
    别名 = '情花任务',
    类型 = '常规玩法'
}

function 任务:任务初始化()
    print('任务:初始化')
end

function 任务:任务更新(sec)
    if self.消失时间 then
        if self.消失时间 <= sec then
            local map = 玩家:取地图(self.MAP)
            if map then
                map:删除NPC(self.NPC)
            end
        end
    end
end

function 任务:任务取详情(玩家)
    return string.format('情花种在了#G%s#W,请速去呵护情花长大。', self.位置)
end

function 任务:任务取消(玩家)
    玩家.其它.情花次数 = 0
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            NPC.人数 = NPC.人数 - 1
            if NPC.人数 <= 0 then
                map:删除NPC(self.NPC)
            end
        end
    end
end

function 任务:任务上线(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if not NPC then
            self:删除()
        end
    end
end

local _地图 = { 1208, 1001 }
function 任务:添加任务(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    self.怪名 = '情花'
    local X, Y = map:取随机坐标() --真坐标
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.情花次数 = v.其它.情花次数 + 1
        if v.其它.情花次数 > 10 then
            v.其它.情花次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.操作次数 = 0
    self.操作时间 = os.time() + 10
    self.等待时间 = 0
    self.操作需求 = 0
    self.NPC =
    map:添加NPC {
        队伍 = self.队伍,
        人数 = #self.队伍,
        时长 = 3600,
        名称 = self.怪名,
        外形 = 3109,
        脚本 = 'scripts/task/常规玩法/日常_情花任务.lua',
        时间 = self.时间,
        X = X,
        Y = Y,
        来源 = self,
        倒时 = false
    }
    self.MAP = map.id
    return true
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_情花任务')
    if 玩家.是否组队 then
        if r then
            for _, v in 玩家:遍历队伍() do
                local rr = v:取任务('日常_情花任务')
                if rr and r.nid == rr.nid then
                    rr:删除()
                    self:掉落包(v, v.其它.情花次数)
                end
            end
        end
        for _, nid in ipairs(self.队伍) do
            local r = 玩家:取玩家(nid)
            if r then
                local w = 玩家:取任务('日常_情花任务')
                if w then
                    w:删除()
                end
            end
        end
    elseif r then
        self:删除()
        self:掉落包(玩家, 玩家.其它.情花次数)
    end
end

local _掉落 = {
    { 几率 = 10, 名称 = '悔梦石', 数量 = 1, 广播 = '#C水水谁%s获得了什么#G#m(%s)[%s]#m#n' },
    { 几率 = 10, 名称 = '亲密丹', 数量 = 1, 参数 = 1000, 广播 = '#C水水谁%s获得了什么#G#m(%s)[%s]#m#n' }
}
function 任务:掉落包(玩家, 次数)
    if 玩家:取活动限制次数('情花任务') > 200 then
        玩家:提示窗口('本日奖励次数已尽,无法继续获得奖励')
        return
    end
    玩家:增加活动限制次数('情花任务')
    local 银子 = 0
    local 经验 = 5000
    --(1+次数*1.2)

    local r = 玩家:取任务('引导_情花任务')
    if r then
        r:添加进度(玩家)
    end

    if 玩家:判断等级是否高于(70) then
        return
    end
    玩家:添加任务经验(经验, '情花')
    玩家:添加银子(银子, '情花')



    for i, v in ipairs(_掉落) do
        if math.random(1000) <= v.几率 then
            local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数 }
            if r then
                玩家:添加物品({ r })
                if v.广播 then
                    玩家:发送系统(v.广播, 玩家.名称, r.ind, r.名称)
                end
                break
            end
        end
    end
end

--===============================================

local 对话 = {
    [[太阳当空照，我是快乐的小花苗#89
menu
1|给我施肥
2|给我捉虫
3|给我浇水
99|你好！再见
]]   ,
    [[太阳当空照，我是快乐的小花苞#89
menu
1|给我施肥
2|给我捉虫
3|给我浇水
99|你好！再见
]]   ,
    [[太阳当空照，我是快乐的小花朵#89
menu
]]
}
function 任务:NPC更新(sec)
    if self.倒时 and sec > self.倒时 then
        self:删除()
    end
end

function 任务:NPC对话(玩家)
    local r = 玩家:取任务('日常_情花任务')
    if r and r.nid == self.来源.nid then
        return 对话[self.来源.进度]
    end
    return '我认识你么？#24'
end

function 任务:NPC菜单(玩家, i)
    if i == '1' or i == '2' or i == '3' then
        if self.来源.操作次数 <= 6 then
            self.来源.操作次数 = self.来源.操作次数 + 1
            local map = 玩家:取地图(self.来源.MAP)
            if self.来源.操作次数 > 6 and self.来源.进度 == 2 then
                self.来源.进度 = 3
                if map then
                    local npc = map:取NPC(self.来源.NPC)
                    npc:切换外形(3111)
                end
                self.来源:完成(玩家)
                self.倒时 = os.time() + 20
            elseif self.来源.操作次数 > 4 and self.来源.进度 == 1 then
                self.来源.进度 = 2
                if map then
                    local npc = map:取NPC(self.来源.NPC)
                    npc:切换外形(3110)
                end
            end
            return '感谢你们的呵护，我正在一点点长大！！！'
        else
            return '我正在茁壮成长，不要揠苗助长哦！'
        end
    end
end

--===============================================

function 任务:战斗初始化(玩家, NPC)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
