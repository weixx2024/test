local 任务 = {
    名称 = '日常_地宫',
    别名 = '地宫挑战',
    类型 = '副本任务'
}

function 任务:任务初始化()
    self.进度 = 1
end

function 任务:任务取详情(玩家)
    return string.format('#Y任务目的:#r#W普通挑战：#G%s，#r#W位于%s#r请前往降服', self.寻路, self.位置)
end

function 任务:任务取消(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            NPC:删除()
        end
    end
    self:删除()
end

function 任务:任务更新(sec, 玩家)
    if sec > self.时间 then
        local map = 玩家:取地图(self.MAP)
        if map then
            local NPC = map:取NPC(self.NPC)
            if NPC then
                NPC:删除()
            end
        end
        self:删除()
    end
end

function 任务:任务上线(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if not NPC then
            玩家:切换地图(1003, 226, 9)
            self:删除()
        end
    end
end

function 任务:任务下线(玩家)
end

local _外形 = {
    2057,
    2056,
}

local _名称 = {
    "的千年小妖",
    "的千年妖王",
    "的万年妖王",
    "的万年魔王",
}


function 任务:添加任务(玩家)
    self.时间 = os.time() + 1800
    self.进度 = 1
    local map = 玩家:取地图(1291)
    if not map then
        return
    end
    local X, Y = map:取随机坐标() --真坐标
    if not X then
        return
    end
    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v:添加任务(self)
    end
    self.怪名 = 玩家.名称 .. _名称[self.难度]
    self.NPC =
        map:添加NPC {
            队伍 = self.队伍,
            人数 = #self.队伍,
            名称 = self.怪名,
            外形 = _外形[math.random(#_外形)],
            脚本 = 'scripts/task/常规玩法/日常_地宫.lua',
            时间 = self.时间,
            任务类型 = "地宫",
            难度 = self.难度,
            X = X,
            Y = Y,
            来源 = self
        }
    self.位置 = string.format('(%d,%d)', X, Y)
    self.MAP = map.id
    self.x = X
    self.y = Y

    self.寻路 = string.format('#u#[1291|%s|%s|$%s#]#u', X, Y, self.怪名)

    return string.format('#Y%s#W在%s显形', self.怪名, self.位置)
end

function 任务:完成击杀(玩家)
    local r = 玩家:取任务("日常_地宫")
    if r then
        for _, v in 玩家:遍历队伍() do
            local rr = v:取任务("日常_地宫")
            if rr and rr.nid == r.nid then
                rr:完成(v)
            end
        end
    end
end

function 任务:完成(玩家)
    self:掉落包(玩家)
    self:删除()
end

--===============================================
_奖励 = {
    { 经验 = 2000000, 积分 = 100 },
    { 经验 = 3000000, 积分 = 200 },
    { 经验 = 4000000, 积分 = 300 },
    { 经验 = 5000000, 积分 = 400 },
}
function 任务:掉落包(玩家)
    if 玩家:取活动限制次数('日常_地宫') >= 4 then
        return
    end

    玩家:增加活动限制次数('日常_地宫')
    local 经验 = _奖励[self.难度].经验
    local 积分 = _奖励[self.难度].积分
    玩家:添加任务经验(经验, "地宫")
    玩家:添加指定积分(积分, "地宫积分")
end

--===============================================
local 对话 = {
    [[幻魔大法刚有小成，你们就送上门来，哼哼，尝尝冒然闯入幻境的苦果吧！
menu
1|狂妄妖魔，速速受死
99|我再整顿下队伍
]],
    [[你们竟然能进入本尊的幻境，也好，就让你们尝尝本尊幻象的威力，送你们上黄泉之路吧！
menu
1|狂妄妖魔，速速受死
99|我再整顿下队伍
]],
    [[
你们竟然能进入本尊的幻境，也好，就让你们尝尝本尊幻象的威力，送你们上黄泉之路吧！
menu
1|狂妄妖魔，速速受死
99|我再整顿下队伍
]],
    [[
幻魔大法刚有小成，你们就送上门来，哼哼，尝尝冒然闯入幻境的苦果吧！
menu
1|狂妄妖魔，速速受死
99|我再整顿下队伍
]],
}



function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "地宫" then
        local r = 玩家:取任务("日常_地宫")
        if r then
            if r.NPC == self.nid or r.NPC2 == self.nid then
                return 对话[math.random(#对话)]
            end
        end
    end
end

local _脚本 = {
    'scripts/war/地宫/简单.lua',
    'scripts/war/地宫/困难.lua',
    'scripts/war/地宫/卓越.lua',
    'scripts/war/地宫/炼狱.lua',
}
function 任务:NPC菜单(玩家, i)
    if i == "1" then
        local r = 玩家:取任务("日常_地宫")
        if r then
            if r.NPC == self.nid or r.NPC2 == self.nid then
                local 脚本 = _脚本[self.难度]
                local sf = 玩家:进入战斗(脚本)
                if sf then
                    r:完成击杀(玩家)
                    self:删除()
                end
            else
                return "我认识你么#24"
            end
        end
    end
end

--===============================================



return 任务
