local 召唤 = require('召唤')

function 召唤:属性_初始化(t)
    if type(t) == 'table' then
        for i=#self.后天技能,1,-1 do
            if self.后天技能[i] == "" then
                table.remove(self.后天技能,i)
            end
        end
        for i, v in ipairs(self.天生技能) do
            table.insert(self.技能, require('对象/法术/技能')({ 名称 = v, 类别 = '召唤' }))
        end

        for i, v in ipairs(self.后天技能) do
            table.insert(self.技能, require('对象/法术/技能')({ 名称 = v, 类别 = '召唤' }))
        end

        if self.神兽技能 and self.神兽技能 ~= 0 then
            table.insert(self.技能, require('对象/法术/技能')({ 名称 = self.神兽技能, 类别 = '召唤' }))
        end
        if type(self.内丹) == 'table' then
            for i, v in ipairs(self.内丹) do
                self.内丹[i] = require('对象/法术/内丹')(v)
            end
        end
    end
    if self.存档指令[4] then
        for nid, v in pairs(self.技能) do
            if v.名称 == self.存档指令[4] then
                self.存档指令[3] = v.nid
                break
            end
        end
    end
    self:刷新属性(t)
    self.顺序 = 1
end

function 召唤:刷新属性(刷新)
    self.抗性 = __容错表 {}
    local 五行 = {"金","木","水","火","土"}
    for i,v in ipairs(五行) do
        self[v] = self.数据[v]
    end

    ---------------计算初值----------------------
    for k, v in pairs(self.天生抗性) do
        self.抗性[k] = self.抗性[k] + v
    end
    for k, v in self:遍历内丹() do
        local t = v:计算(self)
        if type(t) == "table" then
            for kx, s in pairs(t) do
                self.抗性[kx] = self.抗性[kx] + s
            end
        end
    end
    self:亲密抗性计算()
    if self.炼妖 then
        self:炼妖属性计算()
    end


    self.最大气血 = math.ceil(self.成长 * self.等级 * (0.7 * self.初血 + self.根骨) + self.初血)
    self.最大魔法 = math.ceil(self.成长 * self.等级 * (0.7 * self.初法 + self.灵性) + self.初法)
    self.攻击 = math.ceil(self.成长 * 0.2 * self.等级 * (0.7 * self.初攻 + self.力量) + self.初攻)
    self.速度 = math.ceil((self.敏捷 + self.初敏) * self.成长)
    self.最大经验 = self:取升级经验()
    self:基础抗性上限计算(75)

    ------------------------------------坐骑技能属性
    if self.被管制 then
        self.被管制:管制属性计算(self)
        self:坐骑抗性上限计算(75)
    end
    -- 天赋技能加到抗性面板上
    for k, v in self:遍历技能() do
        local t = v:计算(self)
        if type(t) == "table" then
            for kx, s in pairs(t) do
                self.抗性[kx] = self.抗性[kx] + s
            end
        end
        v:计算_召唤(self)
    end
    ----------------------------------
    if self.气血 > self.最大气血 then
        self.气血 = self.最大气血
    end
    if self.魔法 > self.最大魔法 then
        self.魔法 = self.最大魔法
    end
    self.最大气血 = math.ceil(self.最大气血)
    self.最大魔法 = math.ceil(self.最大魔法)
    self.攻击 = math.ceil(self.攻击)
    self.速度 = math.ceil(self.速度)
    if 刷新 == true then
        self.主人.rpc:界面信息_召唤(self:取界面数据())
    end
    -- for i = 1, #上限范围 do
    --     if self.数据[编号][上限范围[i]] > 75 then
    --         self.数据[编号][上限范围[i]] = 75
    --     end
    -- end

    -- if self.管制 ~= nil then
    --     if 玩家数据[self.数字id].坐骑.数据[self.管制.编号] == nil then
    --         self.管制 = nil
    --         return
    --     end
    --     for i = 1, #玩家数据[self.数字id].坐骑.数据[self.管制.编号].技能 do
    --         self:坐骑技能属性(编号, 玩家数据[self.数字id].坐骑.数据[self.管制.编号].技能[i].名称, 玩家数据[self.数字id].坐骑.数据[self.管制.编号].技能[i].熟练度)
    --     end
    -- end
end

function 召唤:亲密抗性计算()
    self.抗性.致命几率 = 3 + 0.1 * (self.亲密 / 10000)
    if self.抗性.致命几率 > 8 then
        self.抗性.致命几率 = 8
    end
    self.抗性.连击率 = 3 + 0.01 * (self.亲密 / 40000)
    if self.抗性.连击率 > 45 then
        self.抗性.连击率 = 45
    end
    self.抗性.连击次数 = 3 + math.floor(0.18 * (self.亲密 / 10000))
    if self.抗性.连击次数 > 7 then
        self.抗性.连击次数 = 7
    end
end

local _坐骑抗性上限 = {
    抗混乱 = true,
    抗昏睡 = true,
    抗封印 = true,
    抗中毒 = true,
}


function 召唤:坐骑抗性上限计算()
    for k, v in pairs(self.抗性) do
        if _坐骑抗性上限[k] then
            self.抗性[k] = v < 95 and v or 95
        else
            self.抗性[k] = v < 85 and v or 85
        end
    end
end

function 召唤:基础抗性上限计算(n)
    for k, v in pairs(self.抗性) do
        self.抗性[k] = v < n and v or n
    end
end

function 召唤:炼妖属性计算()
    for k, v in pairs(self.炼妖) do
        if k ~= "次数" then
            self.抗性[k] = self.抗性[k] + v
        end
    end
end

function 召唤:取升级经验()
    local YJK = require('数据库/经验库')
    local r = 0
    -- if self.点化 == 0 then
    r = YJK.召唤兽经验库[self.等级 + 1]
    if self.召唤兽飞升 == 1 then
        r = YJK.召唤兽飞升经验库[self.等级 + 1]
    end
    -- else
    -- 
    -- end
    return r or 99999999
end

function 召唤:取等级上限()
    local t = { 100, 120, 140, 170, 200 }
    if self.召唤兽飞升  == 1 then
        if self.等级 >= 200 then
            if self.经验 >= self.最大经验 then
                self.经验 = self.最大经验
            end
            return true
        end
    else
        if self.等级 >= t[self.转生 + 1] then
            if self.经验 >= self.最大经验 then
                self.经验 = self.最大经验
            end
            return true
        end
    end
    return false
end
