local 任务 = {
    名称 = '日常_寻芳挑战',
    别名 = '寻芳挑战',
    类型 = '副本任务'
}

function 任务:任务初始化()
    self.进度 = 1
end

local 描述 =
"#Y任务目的:#r#W人生一世,芳草难寻。花点时间和精力，找几个朋友组好队伍去#Y长安#W的#G(326,113）#W寻找#G东君#W,齐心协力挑战之。#Y且记住:寻芳，芳在哪里，众里寻她千百度,灯火阑珊处而己。#r#G你目前己经破除了#Y%s/8#G道封印。"
function 任务:任务取详情(玩家)
    return string.format(描述, self.进度 - 1)
end

function 任务:任务取消(玩家)
    if self.地图 and 玩家.地图 == self.地图.id then
        玩家:切换地图(1001, 321, 113)
        玩家:设置关卡倒计时(0, -1)
    end
    self:删除()
end

function 任务:任务更新(sec, 玩家)
    if self.时长 then
        self.时长 = self.时长 - 1
    end
    if sec > self.时间 and not 玩家.是否战斗 then
        玩家:切换地图(1001, 321, 113)
        玩家:设置关卡倒计时(0, -1)
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if os.time() > self.时间 then
        玩家:切换地图(1001, 321, 113)
        self:删除()
    end
end

function 任务:任务下线(玩家)
end

function 任务:添加任务(玩家)
    self.时间 = os.time() + 1800
    self.时长 = 1800
    self.进度 = 1
    self:生成地图(玩家)

    for k, v in 玩家:遍历队伍() do
        v:添加任务(self)
    end

    玩家:切换地图2(self.地图, 76, 68)
    玩家:设置关卡倒计时(self.进度, self.时长)
    return true
end

local _仙子 = {
    { "一月", "腊梅仙子", 3061 },
    { "二月", "杏花仙子", 17 },
    { "三月", "桃花仙子", 2096 },
    { "四月", "牡丹仙子", 55 },
    { "五月", "石榴仙子", 2012 },
    { "六月", "荷花仙子", 45 },
    { "第七重封印", "蜀葵仙子的大辩才天", 55 }, --
    { "第八重封印", "桂花仙子的紫薇大帝", 54 },

}

function 任务:生成地图(玩家)
    self.地图 = 生成地图(1291)
    self.地图:添加NPC {
        名称 = "东君",
        外形 = 50,
        脚本 = 'scripts/task/常规玩法/日常_寻芳挑战.lua',
        X = 75,
        Y = 75,
        方向 = 2,
        来源 = self
    }
    self.地图:添加NPC {
        名称 = "超级巫医",
        外形 = 3001,
        脚本 = 'scripts/npc/超级巫医.lua',
        X = 90,
        Y = 69,
        方向 = 3,
    }
    local 仙子 = _仙子[self.进度]
    if 仙子 then
        self.地图:添加NPC {
            称谓 = 仙子[1],
            名称 = 仙子[2],
            外形 = 仙子[3],
            脚本 = 'scripts/task/常规玩法/日常_寻芳挑战.lua',
            buf = { 401 },
            X = 66,
            Y = 66,
            方向 = 3,
            来源 = self
        }
    end
end

function 任务:进场(玩家)
    if not self.地图 then
        self:生成地图(玩家)
    end

    玩家:切换地图2(self.地图, 76, 68)
    玩家:设置关卡倒计时(self.进度, self.时长)
end

function 任务:更换NPC(玩家)
    local 仙子 = _仙子[self.进度]
    local next仙子 = _仙子[self.进度 + 1]
    if next仙子 then
        for k, v in self.地图:遍历NPC() do
            if v.名称 == 仙子[2] then
                v:切换外形(next仙子[3])
                v:切换名称(next仙子[2])
                v:切换称谓(next仙子[1])
            end
        end
        self.进度 = self.进度 + 1
        self.时间 = os.time() + 1800
        self.时长 = 1800
        玩家:设置关卡倒计时(self.进度, self.时长)
    end

    if not next仙子 then
        for _, v in 玩家:遍历队伍() do
            local r = v:取任务("日常_寻芳挑战")
            if r then
                v:设置关卡倒计时(0, -1)
                r:删除(v)
            end
        end
        玩家:切换地图(1001, 321, 113)
    end
end

function 任务:掉落包(玩家)
    local r = 玩家:取任务('日常_寻芳挑战')
    if r then
        for i, v in 玩家:遍历队伍() do
            local rr = v:取任务('日常_寻芳挑战')
            if rr and rr.nid == r.nid then
                if v:取活动限制次数('寻芳' .. self.进度) < 1 then
                    v:增加活动限制次数('寻芳' .. self.进度)
                    local 经验 = 1000000 + self.进度 * 500000
                    local 寻芳积分 = self.进度 * 100
                    v:添加任务经验(经验, "寻芳")
                    v:添加指定积分(寻芳积分, "寻芳积分")
                end
            end
        end
    end
end

function 任务:切换地图后事件(玩家, 地图)
    if 地图 and self.地图 and 地图.id ~= self.地图.id then
        玩家:设置关卡倒计时(0, -1)
    end
end

--===============================================
local 对话 =
[[大侠是来解救我的吗
menu
1|是的
2|离开
]]

function 任务:NPC对话(玩家, NPC)
    return 对话
end

function 任务:NPC菜单(玩家, i)
    if i == "1" then
        local rw = 玩家:取任务("日常_寻芳挑战")
        if rw then
            local s = string.format("scripts/war/寻芳/寻芳_%s.lua", rw.进度)
            local r = 玩家:进入战斗(s, self)
            if r then
                rw:掉落包(玩家)
                self.来源:更换NPC(玩家)
            end
        end
    elseif i == "2" then
        玩家:切换地图(1001, 322, 114)
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
