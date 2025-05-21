-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2022-09-07 15:17:32

local 任务 = {
    名称 = '宝图_捣蛋鬼',
    别名 = '宝图任务',
    类型 = '日常任务',
    飞行限制 = true,
}

function 任务:任务初始化(玩家, ...)
end

local _描述 = '去洛阳城%s附近，教训下#R#u#[%s|%s|%s|$捣蛋鬼#]#u#W。今天你已经帮了本客栈%s次。距离本次任务结束时间还有%s分钟，加油！'
function 任务:任务取详情(玩家)
    if self.时间 then
        return string.format(_描述, self.位置, self.mapid, self.x, self.y, self.环数, (self.时间 - os.time()) //
            60)
    end
end

function 任务:任务取消(玩家)
    玩家.其它.宝图环数 = nil
end

function 任务:任务更新(sec, 玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
        玩家.其它.宝图环数 = nil
    end
end

function 任务:任务下线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
        玩家.其它.宝图环数 = nil
    end
end

function 任务:添加任务(玩家) --1寻药
    if 玩家.等级 < 30 then
        return "等级小于30时间宠小于10级的玩家无法领取该任务"
    end
    if 玩家:取时间宠等级() < 10 then
        return "等级小于30时间宠小于10级的玩家无法领取该任务"
    end
    if 玩家.体力 < 20 then
        return "领取该任务需要20点体力"
    end
    local map = 玩家:取地图(1236)
    if not map then
        return
    end
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    玩家:扣除体力(20)

    self.位置 = string.format("(%s,%s)", X, Y)
    玩家.其它.宝图环数 = 玩家.其它.宝图环数 > 30 and 1 or 玩家.其它.宝图环数 + 1
    self.环数 = 玩家.其它.宝图环数
    self.时间 = os.time() + 1800
    self.NPC =
        map:添加NPC {
            名称 = "捣蛋鬼",
            外形 = 46,
            脚本 = 'scripts/task/宝图任务/宝图_捣蛋鬼.lua',
            时长 = 1800,
            任务类型 = "宝图任务",
            X = X,
            Y = Y,
            来源 = self
        }
    self.x = X
    self.y = Y
    self.mapid = map.id
    玩家:添加任务(self)
    return '去洛阳城' .. self.位置 .. '附近，教训下#R捣蛋鬼。'
end

function 任务:掉落包(玩家) --1寻药
    local 经验 = math.floor(59884 * (1 + self.环数 * 0.35)) --1154万经验
    local 银子 = 1000 * (1 + self.环数 * 0.36) --产出197400银两
    local 成就 = 20 * (1 + self.环数 * 0.2) --满次获得2460成就

    print('掉落包', 经验, 银子)
    玩家:添加任务经验(经验, "宝图任务")
    玩家:添加银子(银子, "宝图任务")
    玩家:增加活动限制次数('宝图任务')
    if self.环数 > 2 then
        if not 玩家:取包裹空位() then
            玩家:提示窗口('#Y 你的包裹已经满了！')
            return
        end

        local r = 生成物品 { 名称 = "藏宝图", 数量 = 1 }
        if 玩家:添加物品({ r }) then
            -- 玩家:发送系统(v.广播, 玩家.名称, r.nid, r.名称)
        end
    end
    local map = 玩家:取地图(self.mapid)
    if map then
        map:删除NPC(self.NPC)
    end
    self:删除()
end

--==================================================
local 对话 = [[小小年纪不听话，专门捣蛋？
menu
1|我今天就来教训教训你！
99|小孩子调皮点好，告辞！
]]

function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "宝图任务" then
        local r = 玩家:取任务('宝图_捣蛋鬼')
        if r and NPC.nid == r.NPC then
            return 对话
        end
    end
end

function 任务:NPC菜单(玩家, i)
    if self.任务类型 == "宝图任务" then
        local r = 玩家:取任务('宝图_捣蛋鬼')
        if r and self.nid == r.NPC then
            if i == "1" then
                玩家:进入战斗('scripts/task/宝图任务/宝图_捣蛋鬼.lua', self)
            end
        else
            return "我认识你么？"
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.任务类型 == "宝图" then
        if NPC.nid == self.NPC then
            玩家:进入战斗('scripts/task/宝图任务/宝图_捣蛋鬼.lua', NPC)
        else
            return "我认识你么？"
        end
    end
end

function 任务:战斗初始化(玩家, NPC)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    local r = 玩家:取任务('宝图_捣蛋鬼')
    if r then
        local 怪物属性
        self.npcnid = NPC.nid
        怪物属性 = {
            外形 = 46,
            名称 = "邪恶的捣蛋鬼",
            等级 = 等级,
            气血 = 1 + 转生 * 1 + 等级 * 1,
            魔法 = 1 + 等级 * 1,
            攻击 = 1 + 转生 * 1 + 等级 * 1,
            速度 = 1 + 转生 * 1 + 等级 * 1,
            抗性 = {},
            技能 = {},
            施法几率 = 50,
            是否消失 = false,
        }
        self:加入敌方(1, 生成战斗怪物(怪物属性))


        怪物属性 = {
            外形 = 2171,
            名称 = "捣蛋鬼的跟班",
            等级 = 等级,
            气血 = 1 + 转生 * 1 + 等级 * 1,
            魔法 = 1 + 等级 * 1,
            攻击 = 1 + 转生 * 1 + 等级 * 1,
            速度 = 1 + 转生 * 1 + 等级 * 1,
            抗性 = {},
            技能 = {},
            施法几率 = 50,
            是否消失 = false,
        }
        self:加入敌方(2, 生成战斗怪物(怪物属性))

        怪物属性 = {
            外形 = 2171,
            名称 = "捣蛋鬼的跟班",
            等级 = 等级,
            气血 = 1 + 转生 * 1 + 等级 * 1,
            魔法 = 1 + 等级 * 1,
            攻击 = 1 + 转生 * 1 + 等级 * 1,
            速度 = 1 + 转生 * 1 + 等级 * 1,
            抗性 = {},
            技能 = {},
            施法几率 = 50,
            是否消失 = false,
        }
        self:加入敌方(3, 生成战斗怪物(怪物属性))


        怪物属性 = {
            外形 = 2171,
            名称 = "捣蛋鬼的打手",
            等级 = 等级,
            气血 = 1 + 转生 * 1 + 等级 * 1,
            魔法 = 1 + 等级 * 1,
            攻击 = 1 + 转生 * 1 + 等级 * 1,
            速度 = 1 + 转生 * 1 + 等级 * 1,
            抗性 = {},
            技能 = {},
            施法几率 = 50,
            是否消失 = false,
        }
        self:加入敌方(4, 生成战斗怪物(怪物属性))

        怪物属性 = {
            外形 = 2171,
            名称 = "捣蛋鬼的打手",
            等级 = 等级,
            气血 = 1 + 转生 * 1 + 等级 * 1,
            魔法 = 1 + 等级 * 1,
            攻击 = 1 + 转生 * 1 + 等级 * 1,
            速度 = 1 + 转生 * 1 + 等级 * 1,
            抗性 = {},
            技能 = {},
            施法几率 = 50,
            是否消失 = false,
        }
        self:加入敌方(5, 生成战斗怪物(怪物属性))
    end
end

function 任务:战斗回合开始(dt)

end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务('宝图_捣蛋鬼')
                if r and r.NPC == self.npcnid then
                    r:掉落包(v.对象.接口)
                end
            end
        end
    end
end

return 任务
