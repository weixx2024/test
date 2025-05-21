local _召唤库 = __召唤库
local _存档表 = require('数据库/存档属性_召唤')

local 召唤 = class('召唤')

gge.require('对象/召唤/算法')
gge.require('对象/召唤/通信')
gge.require('对象/召唤/战斗')
local _技能库 = require('数据库/技能库')
local _四维属性 = { '根骨', '灵性', '力量', '敏捷' }

function 召唤:初始化(t)
    self:加载存档(t)
    self.接口 = require('对象/召唤/接口')(self)
    self:属性_初始化(t)
    if not self.nid then
        self.nid = __生成ID()
    end
    if not self.技能格子 or type(self.技能格子)~="table" or self.技能格子.已开 == nil  then --
        local 技能格子 = {已开 = 1 , 封印 = 2 , 未开启 = 5 }
        local 原名 = t.原名
        if _召唤库[原名] and _召唤库[原名].类型 > 5 then
            技能格子 = {已开 = 2 , 封印 = 2 , 未开启 = 4 }
        end
        self.技能格子 = 技能格子
    end
    __召唤[self.nid] = self
    self.刷新的属性 = {}
    self:召唤兽_取名称颜色()
end

function 召唤:更新()
    if next(self.刷新的属性) then
        if self.刷新的属性.是否参战 then
        elseif self.是否参战 then
            if self.刷新的属性.气血 then
                self.主人.rpc:置召唤气血(self.刷新的属性.气血, self.刷新的属性.最大气血)
            end
            if self.刷新的属性.魔法 then
                self.主人.rpc:置召唤魔法(self.刷新的属性.魔法, self.刷新的属性.最大魔法)
            end
            if self.刷新的属性.经验 then
                self.主人.rpc:置召唤经验(self.刷新的属性.经验, self.刷新的属性.最大经验)
            end
        end
        if self.主人.当前查看召唤 == self then
            self.主人.rpc:请求刷新召唤(self.nid)
        end
        self.刷新的属性 = {}
    end
end

function 召唤:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 召唤:__newindex(k, v)
    if _存档表[k] ~= nil then
        if self.刷新的属性 then
            self.刷新的属性[k] = v
        end

        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 召唤:召唤兽_取名称颜色()
    if self.飞升 == 1 then
        self.名称颜色 = 2265576191
    end
end

function 召唤:取简要数据() --地图
    return {
        type = 'sum',
        nid = self.nid,
        名称 = self.名称,
        外形 = self.外形,
        召唤类型 = self.类型,
        染色 = self.染色,
        x = self.x,
        y = self.y
    }
end

function 召唤:取仓库数据() --仓库
    return {
        nid = self.nid,
        名称 = self.名称,
        外形 = self.外形,
        等级 = self.等级,
        转生 = self.转生,
        顺序 = self.顺序,
        获得时间 = self.获得时间,
    }
end

function 召唤:取界面数据()
    return {
        名称 = self.名称,
        忠诚 = self.忠诚,
        外形 = self.外形,
        召唤类型 = self.类型,
        原形 = self.原形, --头像
        气血 = self.气血,
        染色 = self.染色,
        最大气血 = self.最大气血,
        魔法 = self.魔法,
        最大魔法 = self.最大魔法,
        经验 = self.经验,
        最大经验 = self.最大经验
    }
end

function 召唤:取查看数据() --聊天查看

    local nd = {}
    for _, v in self:遍历内丹() do
        table.insert(nd, { 名称 = v.技能, 点化 = v.点化, 转生 = v.转生, 等级 = v.等级 })
    end
    local jn = {}
    for _, v in self:遍历技能() do
        table.insert(jn, { 名称 = v.名称, nid = v.nid, id = v.id })
    end
    return {
        等级 = self.等级,
        名称 = self.名称,
        外形 = self.外形,
        召唤类型 = self.类型,
        转生 = self.转生,
        飞升 = self.飞升,
        染色 = self.染色,
        最大气血 = self.最大气血,
        气血 = self.气血,
        最大魔法 = self.最大魔法,
        魔法 = self.魔法,
        攻击 = self.攻击,
        速度 = self.速度,
        初血 = self.初血,
        初法 = self.初法,
        初攻 = self.初攻,
        初敏 = self.初敏,
        龙涎丸 = self.龙涎丸,
        忠诚 = self.忠诚,
        成长 = self.成长,

        金 = self.金,
        木 = self.木,
        水 = self.水,
        火 = self.火,
        土 = self.土,
        类型 = self.类型,
        技能 = jn,
        天生技能 = self.天生技能,
        后天技能 = self.后天技能,
        神兽技能 = self.神兽技能,
        技能格子 = self.技能格子,
        内丹 = nd,
        炼妖 = self.炼妖 or { 次数 = 0 },
        天生抗性 = self.天生抗性,
        龙之骨 = self.龙之骨
    }
    
end

function 召唤:五行要求规则(mc) 
    local 规则 = _技能库.五行要求规则[mc]
    if 规则 then
        for i,v in pairs(规则) do
            local sz = self[i] or self.抗性[i]
            if sz == nil or sz < v then
                return true
            end
        end
    end
    return false
end

function 召唤:领悟神兽技能()
    if self.类型 > 5 then
        self.亲密 = self.亲密 - 2000000
        self:亲密抗性计算()
        local 可领悟技能 = _技能库.神兽领悟技能
        local 防卡 = 0
        local 目标技能 = 可领悟技能[math.random(1,#可领悟技能)]
        if self.神兽技能 and self.神兽技能 ~= 0 then
            for _,n in ipairs(self.技能) do
                if self.神兽技能 == n.数据.名称 then
                    self.神兽技能 = 目标技能
                    self.技能[_] = require('对象/法术/技能')({ 名称 = 目标技能, 类别 = '召唤'})
                    self:刷新属性()
                    return "#Y你的召唤兽领悟了#G"..目标技能.."#Y并遗忘了#R"..n.数据.名称.."#Y技能！",true
                end
            end
        else
            self.神兽技能 = 目标技能
            table.insert(self.技能, require('对象/法术/技能')({ 名称 = 目标技能, 类别 = '召唤' }))
            self:刷新属性()
            return "#Y领悟了新的技能#G"..目标技能
        end
    else
        return "#Y只有神兽才可以从我这里领悟技能"
    end
end

function 召唤:删除指定技能(name,bh)
    if bh and self.后天技能[bh] then
        local mcs = self.后天技能[bh]
        if mcs ~= name then
            if not self.主人.rpc:确认窗口("#Y技能名称异常，请确认是否要删除#R%s",mcs) then
                return
            end
            name = mcs
        end
    end
    for k, v in ipairs(self.技能) do
        local mc  = type(v) == "table" and v.数据 and v.数据.名称  or v
        if mc == name then
            if self.神兽技能 == name then
                self.神兽技能 = nil
            else
                for i, _ in ipairs(self.后天技能) do
                    local mc  = _
                    if mc == name then
                        table.remove(self.后天技能,i)
                        break
                    end
                end
            end 
            table.remove(self.技能,k)
            self:刷新属性(true)
            return true
        end
    end
    return "你没有这样的技能"
end


function 召唤:取技能数据(name)
    for _, v in self:遍历技能() do
        if v.名称 == name then
            return v:法术取描述(self)
        end
    end
end

--实际没有这个技能 只是你 给学了一个 空技能 防止报错 兼容的

function 召唤:取技能是否领悟(name)
    for k, v in ipairs(self.后天技能) do
        if v == name then
            return true
        end
    end
    return false
end

function 召唤:取技能是否存在(name)
    for k, v in ipairs(self.技能) do
        local str = type(v) == "table" and v.名称 or v
        if str == name then
            return true
        end
    end
    return false
end

function 召唤:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid,
        -- 龙之骨 = self.龙之骨
    }

    for _, k in pairs { '外形', '原名', '等级', '获得时间', '丢弃时间' } do
        r[k] = self[k]
    end
    r.数据 = {}
    for k, v in pairs(_存档表) do
        if type(v) ~= 'table' and self[k] ~= v then
            r.数据[k] = self[k]
        end
    end

    local nds = {}
    for i, v in ipairs(self.内丹) do
        nds[i] = v:取存档数据(self)
    end
    r.数据.内丹 = nds
    r.数据.龙之骨 = self.龙之骨
    r.数据.炼妖 = self.炼妖
    r.数据.天生抗性 = self.天生抗性
    r.数据.后天技能 = self.后天技能
    r.数据.技能格子 = self.技能格子
    r.数据.存档指令 = self.存档指令
    return r
end

function 召唤:遍历内丹()
    return next, self.内丹
end

function 召唤:遍历技能()
    local i = 0
    return function()
        i = i + 1
        if self.技能[i] then
            return i, self.技能[i]
        end
    end
end

function 召唤:洗点()
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

function 召唤:初始化属性(t)
    local 下限 = 70
    local 成长下限 = 70
    if self.宝宝 then
        下限 = 80
        成长下限 = 80
    end
    if self.类型 ~= 1 or not self.捕捉 then
        下限 = 100
        成长下限 = 100
    end
    if self.获取 == 1 then --封印之书
        下限 = 80
        成长下限 = 100
    end
    if not self.等级 then
        self.等级 = 0
    end
    self.初血 = math.floor(self.初血 * math.random(下限, 100) * 0.01)
    self.初法 = math.floor(self.初法 * math.random(下限, 100) * 0.01)
    self.初攻 = math.floor(self.初攻 * math.random(下限, 100) * 0.01)
    self.初敏 = math.floor(self.初敏 * math.random(下限, 100) * 0.01)
    self.成长 = math.floor(self.成长 * math.random(100 * 10000, 1000000) * 0.001) * 0.001
    self.根骨 = self.等级
    self.灵性 = self.等级
    self.力量 = self.等级
    self.敏捷 = self.等级
    local 潜力 = self.等级 * 4
    while 潜力 > 0 do
        local sx = _四维属性[math.random(4)]
        t[sx] = t[sx] + 1
        潜力 = 潜力 - 1
    end
    self.捕捉 = nil
    self.获取 = nil
    -- self:刷新属性(1)
end

function 召唤:加载存档(t)
    if type(t.数据) == 'table' then --加载存档的表
        rawset(self, '数据', t.数据)
        t.数据 = nil
        for k, v in pairs(t) do
            self[k] = v
        end
        for k, v in pairs(_存档表) do
            if type(v) == 'table' and type(self[k]) ~= 'table' then
                self[k] = {}
            end
        end
        self.是否参战 = self.是否参战 == true
        self.是否观看 = self.是否观看 == true
        self.天生技能 = nil
        if self.原名 == "小五叶" or self.原名 == "小浪淘沙" then
            self.类型 = 0
            self.染色 = 0x02020202
        end
    else
        t.后天技能 = {}
        rawset(self, '数据', t)
        self.内丹 = {}
        self.抗性 = {}
        self.龙之骨 = { 次数 = 0, 初血 = 0, 初法 = 0, 初攻 = 0, 初敏 = 0 }
    end
    if _召唤库[t.原名] then --指向元表 '数据库/召唤库'
        setmetatable(self.数据, { __index = _召唤库[t.原名] })
    else
        -- warn('召唤库不存在:', t.原名 or t.名称)
    end
    self.技能 = {}
end

function 召唤:超级巫医()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
    self.忠诚 = 100
end

function 召唤:取巫医消耗()
    return math.ceil((self.最大气血 - self.气血) / 100 + (self.最大魔法 - self.魔法) / 100 +
        (100 - self.忠诚) * 450)
end

function 召唤:添加忠诚度(n)
    if self.忠诚 >= 100 then
        return '#Y召唤兽忠诚已满！'
    end
    self.忠诚 = self.忠诚 + math.floor(n)
    if self.忠诚 > 100 then
        self.忠诚 = 100
    end
    return true
end

function 召唤:解除技能格子(n)
    if self.技能格子.封印 + 1 > 1 then
        self.技能格子.封印 = self.技能格子.封印 - 1
        self.技能格子.已开 = self.技能格子.已开 + 1
        return true
    else
        return false
    end
end

function 召唤:添加战斗领悟技能(str,name)
    if #self.后天技能 >= self.技能格子.已开 then
        if self.技能格子.封印 + 1 > 1 then
            if self:解除技能格子(n) then
                return self.主人.rpc:常规提示('#Y 你的召唤兽在战斗中意外的开启了一个封印的技能格子！') 
            end
        else
            return self.主人.rpc:常规提示('#Y 当前召唤兽技能格子已达到上限，无法继续学习！') 
        end
    end
    技能 = _技能库.普通技能
    local sj = math.random(100)
    if sj <= 10 then
        技能 = _技能库.高级技能
    end
    技能 = 技能[math.random(1,#技能)]

    local 防卡 = 0
    while self:取技能是否领悟(技能) or self:五行要求规则(技能) do
        防卡 = 防卡 + 1
        if 防卡 >= 1000 then return self.主人.rpc:常规提示('#Y没有可以用于领悟的技能') end
        技能 = 技能[math.random(1,#技能)]  
    end
    if 技能 then
        local 冲突 = _技能库.取技能冲突类型(技能)
        local 覆盖技能 = _技能库.冲突组[冲突]
        if 覆盖技能 then
            for i,v in ipairs(覆盖技能) do
                if self:取技能是否领悟(v) then
                    self.待领悟技能 = {技能,v}
                    self.主人.rpc:确认数据窗口("#Y领悟#G"..技能.."#Y将会覆盖#R"..v.."#Y你确认覆盖么？",self.nid)
                    return
                end
            end
        end
        table.insert(self.后天技能,技能)
        table.insert(self.技能, require('对象/法术/技能')({ 名称 = 技能 , 类别 = '召唤'}))
        self:刷新属性(t)
        return self.主人.rpc:常规提示("#Y领悟了新的技能#G"..技能)
    end
end

function 召唤:战斗添加领悟技能(选项)
    if self.待领悟技能 and 选项 then
        for _,n in ipairs(self.技能) do
            if n.数据.名称 == self.待领悟技能[2] then
                for z,x in ipairs(self.后天技能) do
                    if x == self.待领悟技能[2] then
                        self.后天技能[z] = self.待领悟技能[1]
                        self.技能[_] = require('对象/法术/技能')({ 名称 = self.待领悟技能[1], 类别 = '召唤'})
                        self:刷新属性()
                        self.主人.rpc:常规提示("#Y你的召唤兽领悟了#G"..self.待领悟技能[1].."#Y并遗忘了#R"..self.待领悟技能[2].."#Y技能！")
                        self.待领悟技能 = nil
                        return
                    end
                end
            end
        end
    else
        self.待领悟技能 = nil
        return self.主人.rpc:常规提示("#Y你没有选择覆盖技能")
    end
end

function 召唤:添加亲密度(n, r)
    local s = 200000000
    if r == 2 then
        s = 200000000
    end
    if self.亲密 >= s then
        return false
    end
    self.亲密 = self.亲密 + math.floor(n)
    if self.亲密 > s then
        self.亲密 = s
    end
    self:刷新属性()
    -- for k, v in self:遍历内丹() do
    --     v:重新计算属性(self)
    -- end
    return true
end

function 召唤:添加亲密度2()
    local s = 200000000

    if self.亲密 >= s then
        return false
    end
    self.亲密 = self.亲密 + math.floor(self.等级 * 15)
    if self.亲密 > s then
        self.亲密 = s
    end
    self:刷新属性()
    -- for k, v in self:遍历内丹() do
    --     v:重新计算属性(self)
    -- end
    return true
end

function 召唤:删除()
    if self.主人 then
        self.主人.召唤[self.nid] = nil
    end
end

return 召唤
