local _地图 = { 1213, 1173, 1236, 1004, 1005, 1006, 1007 }
local 任务 = {
    名称 = '法宝领取',
    别名 = '心魔挑战',
    类型 = '法宝任务'
}

function 任务:任务初始化(玩家, ...)

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

function 任务:任务下线(玩家)

end

function 任务:任务取消(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            map:删除NPC(self.NPC)
        end
    end
end

function 任务:任务更新(玩家, sec)
end

function 任务:任务取详情(玩家)
    return string.format('#Y任务目的:#r#W去#Y%s#W消灭#G#u#[%s|%s|%s|$%s#]#u#W(剩余%d分钟)', self.位置,
        self.MAP, self.x, self.y,
        self.怪名,
        (self.时间 - os.time()) // 60)
end

function 任务:添加任务(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    self.怪名 = 玩家.名称 .. "的心魔"
    local X, Y = map:取随机坐标() --真坐标
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}
    玩家:添加任务(self)
    self.时间 = os.time() + 1800
    self.NPC =
        map:添加NPC {
            名称 = self.怪名,
            外形 = 玩家.原形 or 玩家.外形,
            脚本 = 'scripts/task/法宝任务/法宝领取.lua',
            时间 = self.时间,
            任务类型 = "法宝领取",
            X = X,
            Y = Y,
            来源 = self
        }

    self.MAP = map.id
    self.x = X
    self.y = Y
    return "心魔出现在" .. self.位置 .. "侠士速去消灭"
end

function 任务:完成(玩家)
    if self.法宝 and not 玩家:取法宝是否存在(self.法宝) then
        local r = 生成法宝 { 名称 = self.法宝 }
        if r then
            玩家:添加法宝(r)
            玩家:常规提示("#Y你获得了#G" .. self.法宝)
        end
    end
    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
    self:删除()
end

--===============================================
local 对话 = [[你可想好，可别自不量力#4
menu
1|妖孽，受死吧#126
2|我认错人了#76
]]

function 任务:NPC对话(玩家, NPC)
    if NPC.任务类型 == "法宝领取" then
        local r = 玩家:取任务("法宝领取")
        if r and r.NPC == NPC.nid then
            return 对话
        end
        return "我认识你么？"
    end
end

function 任务:NPC菜单(玩家, i, NPC)
    if i == '1' then
        玩家:进入战斗('scripts/task/法宝任务/法宝领取.lua', self)
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.任务类型 == "法宝领取" then
        local r = 玩家:取任务("法宝领取")
        if r and r.NPC == NPC.nid then
            玩家:进入战斗('scripts/task/法宝任务/法宝领取.lua', NPC)
            return
        end
        return "我认识你么？"
    end
end

--===============================================
function 任务:战斗初始化(玩家, NPC)
    local 任务 = 玩家:取任务('法宝领取')
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    self.NPC_nid = NPC.nid
    if 任务 then
        local 怪物属性 = {
            外形 = NPC.外形,
            名称 = NPC.名称,
            等级 = 等级,
            气血 = 50000,
            魔法 = 12587 + 等级 * 150,
            攻击 = 25000,
            速度 = 180,
            抗性 = {
                忽视防御程度 = 80,
                忽视防御几率 = 80,
            },
            技能 = {},
            施法几率 = 0,
            是否消失 = false,
        }
        self:加入敌方(1, 生成战斗怪物(怪物属性))
    end
end

function 任务:战斗回合开始(dt)

end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务("法宝领取")
                if r and r.NPC == self.NPC_nid then
                    r:完成(v.对象.接口)
                end
            end
        end
    end
end

return 任务
