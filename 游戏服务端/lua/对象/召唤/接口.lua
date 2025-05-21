--可以访问的属性
local 接口 = {
    名称 = true,
    外形 = true,
    等级 = true,
    转生 = true,
    点化 = true,
    亲密 = true,
    忠诚 = true,
    魔法 = true,
    类型 = true,
    宝宝 = true,
    元气丹 = true,
    携带 = true,
    最大魔法 = true,
    气血 = true,
    原名 = true,
    飞升 = true,
    nid = true,
    rid = true,
    是否参战 = true,
    是否观看 = true,
    最大气血 = true,
    技能=true,
    后天技能=true,
    技能格子=true,
    化形丹 = true,
}
-- 可以访问的方法
local _召唤库 = __召唤库
local _技能库 = require('数据库/技能库')
local GGF = require('GGE.函数')
local _随机天生抗性 = { --todo 改为公用
    "物理吸收",
    -- "抗震慑",
    "抗中毒",
    "抗昏睡",
    "抗封印",
    "抗混乱",
    "抗雷",
    "抗水",
    "抗火",
    "抗风",
    -- "抗风",
    -- "抗风",
    -- "抗风",

}
function 接口:提示窗口(...)
    self.主人.rpc:提示窗口(...)
end

function 接口:取主人接口()
    return self.主人.接口
end

function 接口:常规提示(...)
    self.主人.rpc:常规提示(...)
end

function 接口:增减气血(v)
    if self.气血 >= self.最大气血 then
        return
    end
    if type(v) == 'number' then
        self.气血 = self.气血 + v > self.最大气血 and self.最大气血 or self.气血 + v
        self.气血 = self.气血 < 0 and 0 or self.气血
        return self.气血
    end
end

function 接口:增减魔法(v)
    if self.魔法 >= self.最大魔法 then
        return
    end
    if type(v) == 'number' then
        self.魔法 = self.魔法 + v > self.最大魔法 and self.最大魔法 or self.魔法 + v
        self.魔法 = self.魔法 < 0 and 0 or self.魔法
        return self.魔法
    end
end

function 接口:双加(q, m)
    if type(q) == 'number' and type(m) == 'number' then
        self.气血 = self.气血 + q > self.最大气血 and self.最大气血 or self.气血 + q
        self.魔法 = self.魔法 + m > self.最大魔法 and self.最大魔法 or self.魔法 + m
        self.魔法 = self.魔法 < 0 and 0 or self.魔法
        self.气血 = self.气血 < 0 and 0 or self.气血
        return self.魔法
    end
end

function 接口:添加亲密度(n, r)
    return self:添加亲密度(n, r)
end

function 接口:添加经验(n)
    if self:取等级上限() then
        return false
    end
    if type(n) ~= "number" then
        return false
    end

    if self.主人.转生 == 0 and self.等级 > self.主人.等级 + 15 then
        return false
    end
    local 之前等级 = self.等级
    self.经验 = self.经验 + math.floor(n)
    self.主人.rpc:提示窗口("#Y你的召唤兽#R" .. self.名称 .. "#Y获得了" .. math.floor(n) .. "#Y点经验。")
    if self.经验 >= self.最大经验 then
        while self.经验 >= self.最大经验 and not self:取等级上限() do
            self.经验 = self.经验 - self.最大经验
            self.等级 = self.等级 + 1
            self.根骨 = self.根骨 + 1
            self.灵性 = self.灵性 + 1
            self.力量 = self.力量 + 1
            self.敏捷 = self.敏捷 + 1
            self.潜力 = self.潜力 + 4
            self:添加亲密度(self.等级 * 15)
            self.最大经验 = self:取升级经验()
        end
    end
    if 之前等级 ~= self.等级 then
        self:刷新属性()
        self.气血 = self.最大气血
        self.魔法 = self.最大魔法
    end
    return true
end

function 接口:添加战斗经验(n)
    if self.主人.task:任务添加召唤战斗经验(self.接口) ~= false then
        接口.添加经验(self, n)
    end
end

function 接口:添加召唤兽(name)
    if self.主人:召唤_添加(__沙盒.生成召唤 { 名称 = name, 获取 = 1 }) then
        return true
    end
end

function 接口:丢弃()
    return self:召唤_放生()
end

function 接口:删除()
    local mast = self.主人
    if not self.主人.召唤[self.nid] then
        return false
    end
    if mast.参战召唤 == self then
        self.主人.召唤[self.nid] = nil
        mast.参战召唤 = nil
        mast.rpc:界面信息_召唤()
    end
    if mast.观看召唤 == self then
        mast.观看召唤 = nil
    end
    
    return true
end

function 接口:添加内丹经验(n)
    n = math.floor(n)
    local r = false
    for _, v in ipairs(self.内丹) do
        if v:添加经验(n, self) then
            r = true
            self.主人.rpc:提示窗口("#Y%s的内丹#G%s#Y获得了#R%s#Y点经验", self.名称, v.技能, n)
        end
    end
    self.刷新的属性.内丹 = true
    return r
end

function 接口:凝精聚气丹(n)
    n = math.floor(n)
    local t = {}
    for i, v in ipairs(self.内丹) do
        if v:取经验能否添加(self) then
            table.insert(t, i)
        end
    end
    if #t == 0 then
        self.主人.rpc:提示窗口("#Y暂无可升级内丹")
        return
    end
    local v = t[math.random(#t)]
    if self.内丹[v] then
        self.内丹[v]:添加经验(n, self)
        self.主人.rpc:提示窗口("#Y%s的内丹#G%s#Y获得了#R%s#Y点经验", self.名称, self.内丹[v].技能, n)
        return true
    end
end

function 接口:添加物品(t)
    return self.主人.接口:添加物品(t)
end

function 接口:超级巫医()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
    self.忠诚 = 100
end

function 接口:添加忠诚度(n)
    return self:添加忠诚度(n)
end

local _可变色类型 = {
    [1] = true,
    [2] = true,
    [9] = true,
}

local _可变色类型2 = {
    龙马 = true
}

function 接口:食用变色丹(变色)
    -- if not _可变色类型[self.类型] and not _可变色类型2[self.原名] then
    --     return
    -- end
    if 变色 then
        local rs = math.random(100)
        if rs <= 20 then
            self.染色 = 0x03030303 --绿色
        elseif rs < 50 then
            self.染色 = 0x06060606 --守护
        elseif rs < 60 then
            self.染色 = 0x04040404 --蓝色
        else
            self.染色 = 0x05050505
        end
        self.主人.rpc:常规提示("#Y您的召唤兽一口吞下变色丹，召唤兽颜色发生了变化。")
    else
        self.主人.rpc:常规提示("#Y您的召唤兽一口吞下变色丹。")
    end
    return true
end

function 接口:食用元气丹(成长, 变色, n)
    if not self.元气丹 then
        self.元气丹 = 0
    end
    if 成长 then
        self.成长 = self.成长 - self.元气丹
        self.元气丹 = n
        self.成长 = self.成长 + n
    end

    if 变色 then
        local rs = math.random(100)
        if rs <= 20 then
            self.染色 = 0x02020202
        elseif rs < 50 then
            self.染色 = 0x03030303
        elseif rs < 60 then
            self.染色 = 0x04040404
        else
            self.染色 = 0x05050505
        end
        self.主人.rpc:常规提示("你的召唤兽颜色发生了变化！")
    end

    return true
end

function 接口:添加元气(n)
    if type(n) ~= "number" then
        return
    end
    local 元气 = 0
    local 内丹
    for _, v in ipairs(self.内丹) do
        if v.最大元气 - v.元气 > 元气 then
            元气 = v.最大元气 - v.元气
            内丹 = v
        end
    end

    if 内丹 then
        内丹:增减元气(n)
        self.刷新的属性.内丹 = true
        self.主人.rpc:常规提示("#Y%s#W内丹元气获得补充！", 内丹.技能)
        return true
    end
end

function 接口:添加内丹(t)
    if ggetype(t) == '物品接口' then
        t = t[0x4253]
        if self.接口:取内丹是否存在(name) then
            return
        end
        local r = require('对象/法术/内丹') {
            技能 = t.技能,
            等级 = t.等级,
            经验 = t.经验,
            元气 = t.元气,
            转生 = t.转生,
            点化 = t.点化,
        }
        table.insert(self.内丹, r)
        --  r:属性加(self)
        t:删除()
        self:刷新属性()
        return true
    end
end

local _可用金柳露 = {
    [1] = 1,
    [2] = 1,

}

function 接口:使用金柳露(下限, 上限, 元气丹)
    if not _可用金柳露[self.类型] then
        return "#该类型召唤兽无法使用该道具"
    end
    -- if self.新手召唤 then
    --     return "#该类型召唤兽无法使用该道具"
    -- end

    if #self.内丹 > 0 then
        return "#Y请先吐出内丹"
    end
    local t = _召唤库[self.原名]
    if 上限 > 100 then
        上限 = 100
    end

    if t then
        self.宝宝 = true
        self.等级 = 0
        self.转生 = 0
        self.根骨 = self.等级
        self.灵性 = self.等级
        self.力量 = self.等级
        self.敏捷 = self.等级
        self.初血 = math.floor(t.初血 * math.random(下限 * 10, 上限 * 10) * 0.001)
        self.初法 = math.floor(t.初法 * math.random(下限 * 10, 上限 * 10) * 0.001)
        self.初攻 = math.floor(t.初攻 * math.random(下限 * 10, 上限 * 10) * 0.001)
        self.初敏 = math.floor(t.初敏 * math.random(下限 * 10, 上限 * 10) * 0.001)
        self.成长 = math.floor(t.成长 * math.random(下限 * 10000, 上限 * 10000) * 0.001) * 0.001
        self.潜力 = 0
        self.元气丹 = 0
        self.染色 = 0
        if 元气丹 then
            self.元气丹 = 元气丹
            self.成长 = self.成长 + 元气丹
        end
        self.龙之骨 = { 次数 = 0, 初血 = 0, 初法 = 0, 初攻 = 0, 初敏 = 0 }
        self.天生抗性 = {}
        local kx = _随机天生抗性[math.random(#_随机天生抗性)]
        self.天生抗性[kx] = 30
        self:刷新属性(1)
        return true
    end
end

function 接口:更换天生抗性()
    local n = 0
    for _, v in pairs(self.天生抗性) do
        n = n + 1
    end
    self.天生抗性 = {}
    local kx = math.random(#_随机天生抗性)
    local kx2 = math.random(#_随机天生抗性)

    if kx == kx2 then
        kx2 = _随机天生抗性[kx2 - 1] and kx2 - 1 or kx2 + 1
    end
    self.天生抗性[_随机天生抗性[kx]] = 30
    if n == 2 then
        self.天生抗性[_随机天生抗性[kx2]] = 30
    end
    self:刷新属性()
end

function 接口:刷新属性()
    return self:刷新属性()
end

function 接口:取内丹数量()
    return #self.内丹
end

function 接口:取内丹是否存在(name)
    for _, v in ipairs(self.内丹) do
        if v.技能 == name then
            return true
        end
    end
end

function 接口:使用龙涎丸()
    if self.类型 ~= 4 then
        return 1
    end
    if self.龙涎丸 >= 9 then
        return 2
    end
    self.龙涎丸 = self.龙涎丸 + 1
    self:刷新属性()
    self.成长 = self.成长 + 0.02
    return 3
end

function 接口:使用九转易筋丸()
    if self.转生 ~= 0 then
        return false
    end
    self.转生 = 1
    self.等级 = 15
    self.根骨 = 15
    self.灵性 = 15
    self.力量 = 15
    self.敏捷 = 15
    self.潜力 = 15 * 4 + 30
    if self.化形丹 and self.化形丹 >= 1 then
        self.潜力 = self.潜力 + 60
    end
    --还有哪里会洗召唤兽点  
    self.经验 = 0
    self.成长 = self.成长 + 0.1
    self.最大经验 = self:取升级经验()
    self:刷新属性(1)
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
    self.主人.rpc:常规提示("#Y转生成功！")
    return true
end

function 接口:洗点()
    local a = 0
    for _, v in pairs { '根骨', '灵性', '力量', '敏捷' } do
        a = a + self[v]
    end
    if a == self.等级 * 4 then
        return false
    end

    self.根骨 = self.等级
    self.灵性 = self.等级
    self.力量 = self.等级
    self.敏捷 = self.等级
    if self.召唤兽飞升  == 1 then
        self.根骨 = self.等级 + 60
        self.灵性 = self.等级 + 60
        self.力量 = self.等级 + 60
        self.敏捷 = self.等级 + 60
    end
    self.潜力 = self.等级 * 4 + self.转生 * 30
    if self.化形丹 and self.化形丹 >= 1 then
        self.潜力 = self.潜力 + 60
    end
    -- if self.飞升 == 3 then
    --     self.潜力 = self.潜力 + 60
    -- end
    -- if self.化形 then
    --     self.潜力 = self.潜力 + 60
    -- end
    -- if self.点化 ~= 0 then
    --     self.潜力 = self.潜力 + 60
    -- end
    self:刷新属性(1)
    return true
end

function 接口:使用龙之骨()
    local s = 3
    if self.点化 ~= 0 then
        s = 5
    end

    if not self.龙之骨 then
        self.龙之骨 = { 次数 = 0, 初血 = 0, 初法 = 0, 初攻 = 0, 初敏 = 0 }
    end

    for k, v in pairs { "次数", "初血", "初法", "初攻", "初敏" } do
        if not self.龙之骨[v] then
            self.龙之骨[v] = 0
        end
    end




    if self.龙之骨.次数 >= s then
        return false
    end
    local jl = math.random(100)
    if jl <= 30 then
        self.龙之骨.初血 = self.龙之骨.初血 + 2
        self.龙之骨.初法 = self.龙之骨.初法 + 2
        self.龙之骨.初攻 = self.龙之骨.初攻 + 2
        self.龙之骨.初敏 = self.龙之骨.初敏 + 2
        self.初血 = self.初血 + 2
        self.初法 = self.初法 + 2
        self.初攻 = self.初攻 + 2
        self.初敏 = self.初敏 + 2


        self.主人.rpc:提示窗口('#Y你的' .. self.名称 .. '发生了些许变化,气血初值+2,法力初值+2,攻击初值+2,敏捷初值#R+2#89')
    elseif jl <= 45 then
        self.龙之骨.初敏 = self.龙之骨.初敏 + 6
        self.初敏 = self.初敏 + 6
        self.主人.rpc:提示窗口('#Y你的' .. self.名称 .. '发生了些许变化,敏捷初值#R+6#89')
    elseif jl <= 70 then
        self.龙之骨.初法 = self.龙之骨.初法 + 6
        self.初法 = self.初法 + 6
        self.主人.rpc:提示窗口('#Y你的' .. self.名称 .. '发生了些许变化,法力初值#R+6#89')
    elseif jl <= 85 then
        self.龙之骨.初攻 = self.龙之骨.初攻 + 6
        self.初攻 = self.初攻 + 6
        self.主人.rpc:提示窗口('#Y你的' .. self.名称 .. '发生了些许变化,攻击初值#R+6#89')
    else
        self.龙之骨.初血 = self.龙之骨.初血 + 6
        self.初血 = self.初血 + 6
        self.主人.rpc:提示窗口('#Y你的' .. self.名称 .. '发生了些许变化,气血初值#R+6#89')
    end
    self.龙之骨.次数 = self.龙之骨.次数 + 1
    self.成长 = self.成长 + 0.01
    self:刷新属性()
    return true
end

function 接口:清空龙之骨()
    if not self.龙之骨 then
        self.龙之骨 = { 次数 = 0, 初血 = 0, 初法 = 0, 初攻 = 0, 初敏 = 0 }
    end
    for k, v in pairs { "次数", "初血", "初法", "初攻", "初敏" } do
        if not self.龙之骨[v] then
            self.龙之骨[v] = 0
        end
    end
    -- if self.龙之骨.次数 == 0 then
    --     return false
    -- end
    self.成长 = self.成长 - self.龙之骨.次数 * 0.01

    for _, v in pairs { "初血", "初法", "初攻", "初敏" } do
        self[v] = self[v] - self.龙之骨[v]
    end
    self.龙之骨 = { 次数 = 0, 初血 = 0, 初法 = 0, 初攻 = 0, 初敏 = 0 }
    self:刷新属性()
    self.主人.rpc:提示窗口('#Y你的' .. self.名称 .. '发生了些许变化,龙之骨效果已清除！')
    return true
end

function 接口:转生处理()
    if self.转生 >= 3 then
        self.主人.rpc:常规提示("#Y目前最高转生3转")
        return
    end
    local dkx = { 100, 120, 140 }
    if self.等级 < dkx[self.转生 + 1] then
        self.主人.rpc:常规提示("#Y等级不满足转生条件")
        return
    end
    local qmx = { 100000, 200000, 300000 }
    if self.亲密 < qmx[self.转生 + 1] then
        self.主人.rpc:常规提示("#Y亲密不满足转生条件")
        return
    end
    self.亲密 = self.亲密 - qmx[self.转生 + 1]
    self.转生 = self.转生 + 1
    self.等级 = 15
    self.根骨 = 15
    self.灵性 = 15
    self.力量 = 15
    self.敏捷 = 15
    self.潜力 = 15 * 4 + self.转生 * 30
    if self.化形丹 and self.化形丹 >= 1 then
        self.潜力 = self.潜力 + 60
    end
    self.成长 = self.成长 + 0.1
    -- if self.飞升 == 3 then
    --     self.潜力 = self.潜力 + 60
    -- end
    -- if self.化形 then
    --     self.潜力 = self.潜力 + 60
    -- end

    self:刷新属性()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
    self.主人.rpc:常规提示("#Y转生成功！")
    return true
end

function 接口:召唤兽飞升处理() --内丹飞升 啥效果 就是自动转生  宝宝等级够  跟着宝宝 一起
    if self.转生 < 3 then
        self.主人.rpc:常规提示("#Y该召唤兽未达到飞升条件")
        return
    end
    if self.等级 < 170 then
        self.主人.rpc:常规提示("#Y等级不满足飞升条件")
        return
    end
    if self.亲密 < 1000000 then
        self.主人.rpc:常规提示("#Y亲密不满足转生条件")
        return
    end
    if self.召唤兽飞升 == 1 then
        self.主人.rpc:常规提示("#Y该召唤兽已经飞升过了")
        return
    end
    self.亲密 = self.亲密 - 1000000
    self.召唤兽飞升 = 1
    self.等级 = 15
    self.根骨 = 75
    self.灵性 = 75
    self.力量 = 75
    self.敏捷 = 75
    self.潜力 = 15 * 4 + self.转生 * 30
    if self.化形丹 and self.化形丹 >= 1 then
        self.潜力 = self.潜力 + 60
    end
    self.成长 = self.成长 + 0.1
    self:刷新属性()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
    self:召唤兽_取名称颜色()
    self.主人.rpc:常规提示("#Y飞生成功！")
    return true
end



function 接口:飞升处理(初值, 外形)
    self.飞升 = self.飞升 + 1
    if self.飞升 == 1 then
        self.成长 = self.成长 + 0.1
    elseif self.飞升 == 2 then
        self.成长 = self.成长 + 0.05
    elseif self.飞升 == 3 then
        if 初值 then
            self.飞升初值 = 初值
            self[初值] = self[初值] + 60
        end
    end
    if 外形 then
        self.接口:神兽更换造型(外形)
    end
    self:刷新属性()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
end

function 接口:神兽更换飞升初值(初值)
    if self[初值] then
        self[self.飞升初值] = self[self.飞升初值] - 60
        self.飞升初值 = 初值
        self[初值] = self[初值] + 60
        self:刷新属性()
    end
end

function 接口:解除技能格子(n)
    if self.技能格子.封印 <= 0 then
        return "聚魄丹已经无法继续开启开召唤兽的格子了"
    else
        if math.random(100) <= 20 then
            self.技能格子.封印 = self.技能格子.封印 - 1
            self.技能格子.已开 = self.技能格子.已开 + 1
            return true
        else
            return false
        end
    end
end

function 接口:强开技能格子(n,name)
    if self.技能格子.封印 + 1 > 1 then
        return "前4技能请使用聚魄丹开启"
    else
        if self.技能格子.未开启 <= 0 then
            return "已经没有可以开启的格子了"
        else
            if self.技能格子.未开启 <= 2 and name == "中级聚魄丹" then
                return "7-8技能格需要使用高级聚魄丹开启"
            elseif self.技能格子.未开启 <= 4 and self.技能格子.未开启 > 2 and name == "高级聚魄丹" then
                return "5-6技能格需要使用中级聚魄丹开启"
            end
            if math.random(100) <= 20 then
                self.技能格子.已开 = self.技能格子.已开 + 1
                self.技能格子.未开启 = self.技能格子.未开启 - 1
                return true
            else
                return false
            end
        end
    end
end

function 接口:添加领悟技能(str,name)
    if #self.后天技能 >= self.技能格子.已开 then
        return '#Y 当前召唤兽技能格子已达到上限，无法继续学习！'
    end
    local 技能 = str
    local 可选技能
    if not 技能 then
        if name == "灵兽要诀" then
            可选技能 = _技能库.普通技能
            local sj = math.random(100)
            if sj <= 1 then
                可选技能 = _技能库.高级技能
            end
        elseif name == "万兽要诀" then
            local sj = math.random(100)
            可选技能 = _技能库.高级技能
            if sj <= 5 then
                --可选技能 = {"???"}
            end
        elseif name == "终极技能书" then
            可选技能 = _技能库.终极技能
        end
        技能 = 可选技能[math.random(1,#可选技能)]
        local 防卡 = 0
        while self:取技能是否领悟(技能) or self:五行要求规则(技能) do
            防卡 = 防卡 + 1
            if 防卡 >= 1000 then return '#Y没有可以用于领悟的技能' end
            if 技能[1] == "???" then
                可选技能 = _技能库.高级技能 
            end
            技能 = 可选技能[math.random(1,#可选技能)]  
        end
    elseif self:取技能是否领悟(技能) then
        return '#Y 你已经学会该技能了！'
    end
    local 冲突 = _技能库.取技能冲突类型(技能)
    local 覆盖技能 = _技能库.冲突组[冲突]
    if 覆盖技能 then
        for i,v in ipairs(覆盖技能) do
            if self:取技能是否领悟(v) then
                local r = self.主人.rpc:确认窗口("#Y领悟#G"..技能.."#Y将会覆盖#R"..v.."#Y你确认覆盖么？")
                if r then
                    for _,n in ipairs(self.技能) do
                        if n.数据.名称 == v then
                            for z,x in ipairs(self.后天技能) do
                                if x == v then
                                    self.后天技能[z] = 技能
                                    self.技能[_] = require('对象/法术/技能')({ 名称 = 技能 , 类别 = "召唤"})
                                    self:刷新属性(true)
                                    return "#Y你的召唤兽领悟了#G"..技能.."#Y并遗忘了#R"..x.."#Y技能！",true
                                end
                            end
                        end
                    end
                else
                    return "#Y你没有选择覆盖技能",true
                end
            end
        end
    end
    table.insert(self.后天技能, 技能)
    table.insert(self.技能, require('对象/法术/技能')({ 名称 = 技能 , 类别 = "召唤"}))
    self:刷新属性(true)
    ---
    return "#Y领悟了新的技能#G"..技能, true
end

function 接口:取技能是否领悟(技能)
    return self:取技能是否领悟(技能)
end

function 接口:处理问号技能()
    local 可选技能 = _技能库.终极技能
    local 技能 
    for i,v in ipairs(self.技能) do
        if v.数据.名称 == "???" then
            技能 = 可选技能[math.random(1,#可选技能)]
            while self:取技能是否领悟(技能) do
                技能 = 可选技能[math.random(1,#可选技能)]   
            end
            self.技能[i] = require('对象/法术/技能')({ 名称 = 技能 , 类别 = "召唤"})
            for _,x in ipairs(self.后天技能) do
                if x == "???" then
                    self.后天技能[_] = 技能
                    break
                end
            end
            self:刷新属性(true)
            return true
        end
    end
end

function 接口:是否有问号技能()
    for i,v in ipairs(self.后天技能) do
        if v == "???" then
            return true
        end
    end
end

function 接口:使用化形丹()
    if (self.外形 ~= 2111 and self.外形 ~= 2112 and self.外形 ~= 2114 and self.外形 ~= 2115 and self.外形 ~= 2113) then
        return self.主人.rpc:常规提示("#Y必须是五常神兽或已经服用了化形丹！")
    end
    local 化形成功率 = math.random(100)
    if 化形成功率 > 20 then
        self.亲密 = 0
        self.忠诚 = 0
        self.主人.rpc:常规提示("#G化形失败，你的召唤兽觉得这丹药太难吃了，对你的忠诚及亲密减少了#14")
        return true
    end
    local 新外形 = self.外形 .. 10
    self.外形 = 新外形
    if self.化形丹 == 0 then
        self.化形丹 = 1
        self.潜力 = self.潜力 + 60 --
    end
    self.主人.rpc:常规提示("#G化形成功，你的召唤兽获得了全新的样貌#89")
    return true
end

function 接口:神兽更换造型(外形, 刷新)
    if 外形 then
        self.外形 = 外形

        local t = _召唤库[外形]
        if t then
            self.金 = t.金
            self.木 = t.木
            self.水 = t.水
            self.火 = t.火
            self.土 = t.土
            self.技能 = {}
            self.天生技能 = {}
            t = _召唤库[self.原名] or t
            for i, v in ipairs(t.天生技能) do
                table.insert(self.技能, require('对象/法术/技能')({ 名称 = v, 类别 = '召唤' }))
                table.insert(self.天生技能, v)
            end
            for i, v in ipairs(self.后天技能) do
                table.insert(self.技能, require('对象/法术/技能')({ 名称 = v, 类别 = '召唤' }))
            end
            if self.神兽技能 and self.神兽技能 ~= 0 then
                table.insert(self.技能, require('对象/法术/技能')({ 名称 = self.神兽技能, 类别 = '召唤' }))
            end

            if 刷新 then
                self:刷新属性()
            end
        end
    end
end

function 接口:清空炼妖石()
    self.炼妖 = { 次数 = 0 }
    self:刷新属性()
    return true
end

local _炼妖石上限 = { 3, 8, 11, 11 }
function 接口:使用炼妖石(n, k)
    if not self.炼妖 then
        self.炼妖 = { 次数 = 0 }
    end
    if self.炼妖.次数 >= _炼妖石上限[self.转生 + 1] then
        return "炼妖次数已达上限"
    end
    local list = {}
    if k ~= "抗仙法" then
        list[1] = { k, n } --{类型 数值}
    else
        list[1] = { "抗水", (n - 2) * 0.5 }
        list[2] = { "抗火", (n - 2) * 0.5 }
        list[3] = { "抗雷", (n - 2) * 0.5 }
        list[4] = { "抗风", (n - 2) * 0.5 }
    end
    for _, v in ipairs(list) do
        if not self.炼妖[v[1]] then
            self.炼妖[v[1]] = 0
        end
        self.炼妖[v[1]] = self.炼妖[v[1]] + v[2]
    end
    self.炼妖.次数 = self.炼妖.次数 + 1
    self:刷新属性()
    return true
end

function 接口:管制处理(Z)
    self.被管制 = Z
    self:刷新属性()
end

function 接口:取管制()
    return self.被管制
end

function 接口:添加后天技能(name)
    for k, v in self:遍历技能() do
        if v.名称 == name then
            self.主人.rpc:常规提示("#Y召唤兽已领悟该技能！")
            return
        end
    end
    if #self.后天技能 >= self.技能格子.已开 then
        self.主人.rpc:常规提示("#Y召唤兽已已经没有足够的格子学习新的技能！")
        return false
    end
    table.insert(self.后天技能, name)
    table.insert(self.技能, require('对象/法术/技能')({ 名称 = name, 类别 = '召唤' }))
    self:刷新属性()
    return true
end

--===============================================================================
if not package.loaded.召唤接口_private then
    package.loaded.召唤接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('召唤接口_private')

local 召唤接口 = class('召唤接口')

function 召唤接口:初始化(P)
    _pri[self] = P
    self.是否召唤 = true
end

function 召唤接口:__index(k)
    if k == 0x4253 then
        return _pri[self]
    end
    local r = 接口[k]
    local P = _pri[self]
    if r == true then
        return P[k]
    elseif r then
        return function(_, ...)
            return r(P, ...)
        end
    end
end


return 召唤接口
