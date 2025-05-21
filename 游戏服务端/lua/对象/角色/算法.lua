local 角色 = require('角色')
local _整数范围 = {
    根骨 = true,
    灵性 = true,
    敏捷 = true,
    力量 = true,
    基础攻击 = true,
    附加攻击 = true,
    每回合HP = true,
    每回合MP = true,
    速度 = true,
    防御值 = true,
    附加气血 = true,
    附加魔法 = true,
    连击次数 = true,
    反击次数 = true,
    抗毒伤害 = true,
    尘埃落定 = true,
    化血成碧 = true,
    上善若水 = true,
    灵犀一点 = true,
    明珠有泪 = true,
    美人迟暮 = true,
    抗中毒伤害 = true,
    -- 孩子装备属性
    气质 = true,
    悟性 = true,
    智力 = true,
    内力 = true,
    耐力 = true,
}
local JYK = require('数据库/经验库')
function 角色:刷新属性(来源)
    self.抗性 = __容错表 {}
    self.特技 = {}
    local 五行 = { "金", "木", "水", "火", "土" }
    for i, v in ipairs(五行) do
        self[v] = 0
    end
    self:天生抗性计算()
    self:刷新装备属性()
    self:前特技属性计算()
    self:刷新法宝属性()
    for k, v in pairs(self.装备抗性) do
        self.抗性[k] = self.抗性[k] + v
    end
    self:守护抗性计算()
    self:修正属性计算()
    self:基础属性计算()
    self.最大气血 = math.floor(self.最大气血 + self.装备属性.附加气血)
    self.最大气血 = math.floor(self.最大气血 * (1 + self.抗性.HP成长))
    self.最大气血 = math.floor(self.最大气血 * (1 + self.抗性.气血增加率 * 0.01))
    self.最大魔法 = math.floor(self.最大魔法 + self.装备属性.附加魔法)
    self.最大魔法 = math.floor(self.最大魔法 * (1 + self.抗性.MP成长))
    self.攻击 = math.floor(self.攻击 + self.装备属性.附加攻击 + self.装备属性.基础攻击)
    self.速度 = math.floor(self.速度 + self.装备属性.速度)
    self.速度 = math.floor(self.速度 * (1 + self.抗性.SP成长))
    self:后特技属性计算()
    self:抗性上限计算()
    self.最大经验 = self:取升级经验()
    self.召唤兽携带上限 = 5 + self.转生 * 3
    self.最大体力 = 10 * (60 + self.等级 + 50 * self.转生)
    if self.气血 > self.最大气血 or self.气血 == 0 then
        self.气血 = self.最大气血
    end
    if self.魔法 > self.最大魔法 or self.魔法 == 0 then
        self.魔法 = self.最大魔法
    end
    if 来源 == 1 then
        self.气血 = self.最大气血
        self.魔法 = self.最大魔法
    end
    self.task:增益符文计算(self)
    self.task:强法符文计算(self)
    self.task:抗性符文计算(self)
    --
    -- if self._窗口.人物 then
    --     self._rpc:刷新人物窗口(self:角色_取窗口属性())
    -- end
    -- if self._窗口.人物抗性 then
    --     self._rpc:刷新人物抗性窗口(self:取抗性数据())
    -- end
end

function 角色:天生抗性计算()
    if self.种族 == 1 then --'人'
        self.抗性.抗混乱 = self.等级 * 0.25
        self.抗性.抗封印 = self.等级 * 0.25
        self.抗性.抗昏睡 = self.等级 * 0.25
        self.抗性.抗中毒 = self.等级 * 0.25
    elseif self.种族 == 2 then --'魔'
        self.抗性.物理吸收 = self.等级 * 0.125
        self.抗性.抗混乱 = self.等级 * 0.125
        self.抗性.抗封印 = self.等级 * 0.125
        self.抗性.抗昏睡 = self.等级 * 0.125
        self.抗性.抗中毒 = self.等级 * 0.125
        self.抗性.抗风 = self.等级 * 0.083
        self.抗性.抗火 = self.等级 * 0.083
        self.抗性.抗水 = self.等级 * 0.083
        self.抗性.抗雷 = self.等级 * 0.083
        self.抗性.致命几率 = 5
        self.抗性.狂暴几率 = 5
    elseif self.种族 == 3 then --'仙'
        self.抗性.抗风 = self.等级 * 0.25
        self.抗性.抗火 = self.等级 * 0.25
        self.抗性.抗水 = self.等级 * 0.25
        self.抗性.抗雷 = self.等级 * 0.25
    elseif self.种族 == 4 then --'鬼'
        self.抗性.抗混乱 = self.等级 * 0.166
        self.抗性.抗封印 = self.等级 * 0.166
        self.抗性.抗昏睡 = self.等级 * 0.166
        self.抗性.抗中毒 = self.等级 * 0.166
        self.抗性.抗遗忘 = self.等级 * 0.166
        self.抗性.抗鬼火 = self.等级 * 0.166
        self.抗性.躲闪率 = self.等级 * 0.25
        self.抗性.抗三尸虫 = self.等级 * 20
        self.抗性.抗风 = (0 - self.等级 * 0.125)
        self.抗性.抗火 = (0 - self.等级 * 0.125)
        self.抗性.抗水 = (0 - self.等级 * 0.125)
        self.抗性.抗雷 = (0 - self.等级 * 0.125)
    end
end

local _修正属性 = {
    [1001] = {
        { 抗混乱 = 10.25, 抗封印 = 10.25, 抗昏睡 = 10.25 },
        { 抗混乱 = 15.37, 抗封印 = 15.37, 抗昏睡 = 15.37 },
        { 抗混乱 = 20.5, 抗封印 = 20.5, 抗昏睡 = 20.5 },
        { 抗混乱 = 20.5, 抗封印 = 20.5, 抗昏睡 = 20.5 },
    },
    [1002] = {
        { 抗中毒 = 13.83, 抗毒伤害 = 820, 抗封印 = 10.25, 抗昏睡 = 10.25 },
        { 抗中毒 = 20.83, 抗毒伤害 = 1230, 抗封印 = 15.37, 抗昏睡 = 15.37 },
        { 抗中毒 = 27.67, 抗毒伤害 = 1640, 抗封印 = 20.5, 抗昏睡 = 20.5 },
        { 抗中毒 = 27.67, 抗毒伤害 = 1640, 抗封印 = 20.5, 抗昏睡 = 20.5 },
    },
    [2001] = {
        { HP成长 = 0.082, MP成长 = 0.082, SP成长 = 0.061 },
        { HP成长 = 0.123, MP成长 = 0.123, SP成长 = 0.092 },
        { HP成长 = 0.164, MP成长 = 0.164, SP成长 = 0.123 },
        { HP成长 = 0.164, MP成长 = 0.164, SP成长 = 0.123 },
    },
    [2002] = {
        { HP成长 = 0.082, MP成长 = 0.082, 物理吸收 = 15.37, 抗震慑 = 9.21 },
        { HP成长 = 0.123, MP成长 = 0.123, 物理吸收 = 23.05, 抗震慑 = 13.82 },
        { HP成长 = 0.164, MP成长 = 0.164, 物理吸收 = 30.74, 抗震慑 = 18.42 },
        { HP成长 = 0.164, MP成长 = 0.164, 物理吸收 = 30.74, 抗震慑 = 18.42 },
    },
    [3001] = {
        { 抗水 = 13.83, 抗雷 = 13.83, 抗风 = 13.83 },
        { 抗水 = 20.75, 抗雷 = 20.75, 抗风 = 20.75 },
        { 抗水 = 27.67, 抗雷 = 27.67, 抗风 = 27.67 },
        { 抗水 = 27.67, 抗雷 = 27.67, 抗风 = 27.67 },
    },
    [3002] = {
        { 抗水 = 13.83, 抗雷 = 13.83, 抗火 = 13.83 },
        { 抗水 = 20.75, 抗雷 = 20.75, 抗火 = 20.75 },
        { 抗水 = 27.67, 抗雷 = 27.67, 抗火 = 27.67 },
        { 抗水 = 27.67, 抗雷 = 27.67, 抗火 = 27.67 },
    },
    [4001] = {
        { 抗鬼火 = 13.84, 抗遗忘 = 10.25, 抗三尸虫 = 2050 },
        { 抗鬼火 = 20.76, 抗遗忘 = 15.38, 抗三尸虫 = 3075 },
        { 抗鬼火 = 27.68, 抗遗忘 = 20.5, 抗三尸虫 = 4100 },
        { 抗鬼火 = 27.68, 抗遗忘 = 20.5, 抗三尸虫 = 4100 },
    },
    [4002] = {
        { 抗鬼火 = 13.84, 抗遗忘 = 10.25, 反震率 = 5.13, 反震程度 = 10.25 },
        { 抗鬼火 = 20.76, 抗遗忘 = 15.38, 反震率 = 7.69, 反震程度 = 15.38 },
        { 抗鬼火 = 27.68, 抗遗忘 = 20.5, 反震率 = 10.25, 反震程度 = 20.5 },
        { 抗鬼火 = 27.68, 抗遗忘 = 20.5, 反震率 = 10.25, 反震程度 = 20.5 },
    }
}

local _转生记录 = {
    [1001] = { 抗混乱 = 1, 抗封印 = 1, 抗昏睡 = 1, 种族 = 1001 },
    [1002] = { 抗中毒 = 1, 抗毒伤害 = 1, 抗封印 = 1, 抗昏睡 = 1, 种族 = 1002 },
    [2001] = { HP成长 = 1, MP成长 = 1, SP成长 = 1, 种族 = 2001 },
    [2002] = { HP成长 = 1, MP成长 = 1, 物理吸收 = 1, 抗震慑 = 1, 种族 = 2002 },
    [3001] = { 抗水 = 1, 抗雷 = 1, 抗风 = 1, 种族 = 3001 },
    [3002] = { 抗水 = 1, 抗雷 = 1, 抗火 = 1, 种族 = 3002 },
    [4001] = { 抗鬼火 = 1, 抗遗忘 = 1, 抗三尸虫 = 1, 种族 = 4001 },
    [4002] = { 抗鬼火 = 1, 抗遗忘 = 1, 反震率 = 1, 反震程度 = 1, 种族 = 4002 }
}

local _守护范围 = {
    { 500,      4000,     1,  0 },
    { 4000,     13500,    2,  1 },
    { 13500,    32000,    3,  1 },
    { 32000,    62500,    4,  2 },
    { 62500,    108000,   5,  2 },
    { 108000,   171500,   6,  3 },
    { 171500,   256000,   7,  3 },
    { 256000,   364500,   8,  4 },
    { 364500,   500000,   9,  4 },
    { 500000,   665500,   10, 5 },
    { 665500,   864000,   11, 5 },
    { 864000,   1098500,  12, 6 },
    { 1098500,  1372000,  13, 6 },
    { 1372000,  1687500,  14, 7 },
    { 1687500,  2048000,  15, 7 },
    { 2048000,  2456500,  16, 8 },
    { 2456500,  2916000,  17, 8 },
    { 2916000,  3429500,  18, 9 },
    { 3429500,  4000000,  19, 9 },
    { 4000000,  4630500,  20, 10 },
    { 4630500,  5324000,  21, 10 },
    { 5324000,  6083500,  22, 11 },
    { 6083500,  6912000,  23, 11 },
    { 6912000,  7812500,  24, 12 },
    { 7812500,  8788000,  25, 12 },
    { 8788000,  9841500,  26, 13 },
    { 9841500,  10976000, 27, 13 },
    { 10976000, 12194500, 28, 14 },
    { 12194500, 13500000, 29, 14 },
}


local _修正转换 = {
    抗封印 = { --1
        抗封印 = true,
        物理吸收 = true,
        抗震慑 = true,
        SP成长 = true,
        抗雷 = true,
    },
    抗混乱 = { --2
        抗混乱 = true,
        抗毒伤害 = true,
        抗中毒 = true,
        MP成长 = true,
        抗风 = true,
        抗火 = true,
    },
    抗昏睡 = { --3
        抗昏睡 = true,
        HP成长 = true,
        抗水 = true,
    },
    抗毒伤害 = { --2
        抗混乱 = true,
        抗毒伤害 = true,
        抗中毒 = true,
        MP成长 = true,
        抗风 = true,
        抗火 = true,
    },
    抗中毒 = { --2
        抗混乱 = true,
        抗毒伤害 = true,
        抗中毒 = true,
        MP成长 = true,
        抗风 = true,
        抗火 = true,
    },
    HP成长 = { --2
        抗昏睡 = true,
        HP成长 = true,
        抗水 = true,
    },
    MP成长 = { --2
        抗混乱 = true,
        抗毒伤害 = true,
        抗中毒 = true,
        MP成长 = true,
        抗风 = true,
        抗火 = true,
    },
    SP成长 = { --2
        抗封印 = true,
        物理吸收 = true,
        抗震慑 = true,
        SP成长 = true,
        抗雷 = true,
    },
    物理吸收 = { --2
        抗封印 = true,
        物理吸收 = true,
        抗震慑 = true,
        SP成长 = true,
        抗雷 = true,
    },
    抗震慑 = { --2
        抗封印 = true,
        物理吸收 = true,
        抗震慑 = true,
        SP成长 = true,
        抗雷 = true,
    },
    抗水 = { --2
        抗昏睡 = true,
        HP成长 = true,
        抗水 = true,
    },
    抗雷 = { --2
        抗封印 = true,
        物理吸收 = true,
        抗震慑 = true,
        SP成长 = true,
        抗雷 = true,
    },
    抗风 = { --2
        抗混乱 = true,
        抗毒伤害 = true,
        抗中毒 = true,
        MP成长 = true,
        抗风 = true,
        抗火 = true,
    },
    抗火 = { --2
        抗混乱 = true,
        抗毒伤害 = true,
        抗中毒 = true,
        MP成长 = true,
        抗风 = true,
        抗火 = true,
    },




}

-- 修复修正系数 = 1 ,修复法不满转生的
function 角色:重选修正(t)
    self.转生记录 = {}

    for i, v in ipairs(t) do
        local 种族 = t[i]
        local 当世修正 = _转生记录[种族]
        table.insert(self.转生记录, 当世修正)
    end

    self:刷新属性()
end

-- 保留原修正系数
function 角色:重选修正_初级(t)
    local list = {}
    for i, v in ipairs(self.转生记录) do
        local zz = t[i]
        if zz then
            local xz = _修正属性[zz][i]
            list[i] = {}
            list[i].种族 = zz
            for kx, s in pairs(xz) do
                local zh = _修正转换[kx]
                for yz, value in pairs(zh) do
                    if v[yz] then
                        list[i][kx] = v[yz]
                    end
                end
            end
        end
    end
    self.转生记录 = {}
    for _, v in ipairs(list) do
        table.insert(self.转生记录, v)
    end
    self:刷新属性()
end

-- if n >= v.范围[1] and n <= v.范围[2] then
--     t.名称 = v.名称
--     break
-- end
function 角色:取守护数值()
    local n = self.帮派对象:取成员帮派贡献(self.nid)
    if self.帮派贡献 ~= n then
        self.帮派贡献 = n
    end
    if self.帮派贡献 >= 13500000 then
        return { 30, 15 }
    end

    for i, v in ipairs(_守护范围) do
        if self.帮派贡献 >= v[1] and self.帮派贡献 < v[2] then
            return { v[3], v[4] }
        end
    end
    return { 0, 0 }
end

function 角色:守护抗性计算()
    if self.帮派对象 then
        local t = self:取守护数值()
        for k, v in pairs(self.守护抗性) do
            self.抗性[v] = self.抗性[v] + t[k]
        end
    end
end

function 角色:修正属性计算()
    if self.转生记录 then
        for k, v in ipairs(self.转生记录) do
            for kx, sz in pairs(_修正属性[v.种族][k]) do
                if v[kx] then
                    if _整数范围[kx] then
                        self.抗性[kx] = self.抗性[kx] + math.floor(v[kx] * sz)
                    else
                        self.抗性[kx] = self.抗性[kx] + (math.floor(v[kx] * sz * 1000) * 0.001)
                    end
                end
            end
        end
    end
end

function 角色:刷新装备属性()
    self.装备属性 = __容错表 {}
    self.装备抗性 = __容错表 {}
    for _, v in pairs(self.装备) do
        if v.是否有效 ~= false then
            v:穿上(self)
        end
    end
end

local _卦象 = {
    ["111"] = "抗封印",
    ["000"] = "抗混乱",
    ["001"] = "抗雷",
    ["110"] = "抗风",
    ["100"] = "抗昏睡",
    ["011"] = "抗中毒",
    ["010"] = "抗水",
    ["101"] = "抗火",
}
function 角色:刷新法宝属性()
    local 总等级 = 0
    local 佩戴 = 0
    local 类型 = ""
    for k, v in self:遍历佩戴法宝() do
        总等级 = 总等级 + v.等级
        佩戴 = 佩戴 + 1
        类型 = 类型 .. v.阴阳
    end
    if 佩戴 == 3 then
        local kx = _卦象[类型]
        if kx then
            self.抗性[kx] = self.抗性[kx] + math.floor(总等级 * 0.4) * 0.1
        end
    end
end

function 角色:检查装备()
    local list = {}
    for _, v in pairs(self.装备) do
        if v.是否有效 ~= false and v:检查要求(self) ~= true then
            v:脱下(self)
            table.insert(list, v.名称)
        end
    end
    if #list > 0 then
        --你的%s不够，不能装备%s。
        self.rpc:提示窗口('#R%s#W不满足穿带要求！', table.concat(list, ', '))
    end
end

function 角色:基础属性计算()
    local e = (100 - self.等级) / 5
    local 根骨 = self.装备属性.根骨 + self.根骨 + self.其它.四维加成 * 10
    local 灵性 = self.装备属性.灵性 + self.灵性 + self.其它.四维加成 * 10
    local 力量 = self.装备属性.力量 + self.力量 + self.其它.四维加成 * 10
    local 敏捷 = self.装备属性.敏捷 + self.敏捷 + self.其它.四维加成 * 10
    if self.种族 == 1 then --'人'
        self.最大气血 = (self.等级 + e) * 根骨 * 1.2 + 360
        self.最大魔法 = (self.等级 + e) * 灵性 * 1 + 300
        self.攻击 = (self.等级 + e) * 力量 * 0.95 / 5 + 70
        self.速度 = (10 + 敏捷) * 0.8
    elseif self.种族 == 2 then --魔
        self.最大气血 = (self.等级 + e) * 根骨 * 1.1 + 330
        self.最大魔法 = (self.等级 + e) * 灵性 * 0.6 + 210
        self.攻击 = (self.等级 + e) * 力量 * 1.3 / 5 + 80
        self.速度 = (10 + 敏捷) * 1.2
    elseif self.种族 == 3 then --仙
        self.最大气血 = (self.等级 + e) * 根骨 * 1 + 300
        self.最大魔法 = (self.等级 + e) * 灵性 * 1.4 + 390
        self.攻击 = (self.等级 + e) * 力量 * 0.7 / 5 + 70
        self.速度 = (10 + 敏捷) * 1
    elseif self.种族 == 4 then --鬼
        self.最大气血 = (self.等级 + e) * 根骨 * 1.25 + 270
        self.最大魔法 = (self.等级 + e) * 灵性 * 1.05 + 350
        self.攻击 = (self.等级 + e) * 力量 * 0.95 / 5 + 80
        self.速度 = (10 + 敏捷) * 0.85
    end
end

function 角色:前特技属性计算()
    for i,v in self:遍历特技() do
        v:计算_前特技(self)
    end
end

function 角色:后特技属性计算()
    for i,v in self:遍历特技() do
        v:计算_后特技(self)
    end
end

local 抗性上限 = {
    { 抗封印 = 140, 抗昏睡 = 140, 抗混乱 = 140, 抗遗忘 = 140, 抗中毒 = 100 },
    { 抗封印 = 110, 抗昏睡 = 110, 抗混乱 = 110, 抗遗忘 = 110, 抗中毒 = 110 },
    { 抗封印 = 110, 抗昏睡 = 110, 抗混乱 = 110, 抗遗忘 = 110, 抗中毒 = 110 },
    { 抗封印 = 120, 抗昏睡 = 120, 抗混乱 = 120, 抗遗忘 = 140, 抗中毒 = 110 }
}
setmetatable(
    抗性上限,
    {
        __index = function(_, v)
            print('种族不存在', v)
            return {}
        end
    }
)
function 角色:抗性上限计算()
    local 上限 = 75
    if self.种族 == 3 then --'魔'
        上限 = 80
    end
    上限 = 上限
    for k, v in pairs { '致命几率', '反击率', '连击率', '命中率', '躲闪率', '狂暴几率' } do -- '物理吸收',
        if self.抗性[v] > 上限 then
            self.抗性[v] = 上限
        end
    end

    local 物理吸收抗性 = (self.抗性.物理吸收抗性上限 or 0)
    if self.抗性.物理吸收 > 130 + 物理吸收抗性 then
        self.抗性.物理吸收 = 130 + 物理吸收抗性
    end

    for k, v in pairs(抗性上限[self.种族]) do
        if self.抗性[k] > v + (self.抗性[k .. "上限"] or 0) then
            self.抗性[k] = v + (self.抗性[k .. "上限"] or 0)
        end
    end
end

function 角色:取升级经验()
    local 数值 = 10
    数值 = JYK.人物经验库[self.转生 + 1][self.等级 + 1] or 999999999
    if self.转生 == 3 and self.等级 > 140 then
        数值 = 数值 * 10
    end
    if self.飞升 ~= 0 then
        数值 = JYK.人物经验库[5][self.等级 + 1 - 140]
    end
    if 数值 == nil then
        return 999999999
    end
    return 数值
end

local 转生值 = { 102, 122, 142, 180 }
function 角色:取等级上限()
    if self.飞升 ~= 0 and self.等级 >= 200 then
        local r = self:取升级经验()
        if self.经验 > r then
            self.经验 = r - 1
        end
        return true
    end
    if self.飞升 == 0 then
        if self.等级 >= 转生值[self.转生 + 1] then
            local r = self:取升级经验()
            if self.经验 > r then
                self.经验 = r - 1
            end
            return true
        end
    end

    return false
end
