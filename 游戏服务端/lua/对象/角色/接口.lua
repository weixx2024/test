-- 可以访问的属性
local 接口 = {
    名称 = true,
    等级 = true,
    转生 = true,
    飞升 = true,
    nid = true,
    uid = true,
    创建时间 = true,
    外形 = true,
    原形 = true,
    称谓 = true,
    称谓剧情 = true,
    帮派 = true,
    性别 = true,
    种族 = true,
    气血 = true,
    地图 = true,
    银子 = true,
    师贡 = true,
    最大气血 = true,
    魔法 = true,
    最大魔法 = true,
    X = true,
    Y = true,
    x = true,
    y = true,
    是否组队 = true,
    是否队长 = true,
    是否战斗 = true,
    是否移动 = true,
    帮派成就 = true,
    帮派贡献 = true,
    VIP = true,
    id = true,
    交易锁 = true,
    安全码 = true,
    管理 = true,
    体力 = true,
    其它 = true,
    神行符 = true,
    是否机器人 = true,
    复活标记 = true,
    补偿领取 = true,
    月卡 = true,
    推广奖励 = true,
    月卡数据 = {},
    金 = true,
    木 = true,
    水 = true,
    火 = true,
    土 = true,
}
local GGF = require('GGE.函数')
function 接口:祝福券()
    __世界:发送系统('#Y玩家#R' .. self.名称 .. '#Y在#G' .. self.当前地图.名称 .. '#Y打开了祝福劵#46,当前地图玩家获得一小时三倍经验加成#89!!!')
    for k, v in self.当前地图:遍历玩家() do
        if v and v.接口 then
            local r = v.接口:取任务('祝福券')
            if r then -- 已经区分  这是有的
                r:增加时长(v, 1)
            else      -- 这是没有的
                v.接口:添加任务('祝福券')
            end
            v.rpc:常规提示('#Y你得到了#G' .. self.名称 .. '#Y的祝福')
        end
    end
end

-- 可以访问的方法
function 接口:提示窗口(...)
    self.rpc:提示窗口(...)
end

function 接口:常规提示(...)
    self.rpc:常规提示(...)
end

function 接口:常规提示_队伍(...)
    for _, v in self:遍历队伍() do
        v.rpc:常规提示(...)
    end
end

function 接口:聊天框提示(...)
    self.rpc:聊天框提示(...)
end

function 接口:最后对话(...)
    self.rpc:最后对话(...)
end

function 接口:打开窗口(...)
    self.rpc:打开窗口(...)
end

function 接口:自动任务(...)
    -- if self.VIP < 1 then
    --     return
    -- end
    self.rpc:自动任务_数据(...)
end

function 接口:自动任务_战斗结束(...)
    self.rpc:自动任务_战斗结束(...)
end

function 接口:选择窗口(...)
    return self.rpc:选择窗口(...)
end

function 接口:选择窗口2(...)
    return self.rpc:选择窗口2(...)
end

function 接口:创建帮派窗口(...)
    return self.rpc:创建帮派窗口(...)
end

function 接口:响应帮派窗口(...)
    return self.rpc:响应帮派窗口(...)
end

function 接口:申请帮派窗口(t)
    return self.rpc:申请帮派窗口(t)
end

function 接口:进入帮派(name)
    return self:角色_帮派进入地图(name)
end

function 接口:进入帮战地图(t)
    if not __帮战:能否进场() then
        return "当前非进场时间"
    end
    if not self.帮派对象 then
        return "你当前没有加入帮派"
    end
    if self.帮派对象 then
        return self.帮派对象:进入帮战地图(self, t)
    end
end

function 接口:帮战是否失败(t)
    if self.帮派对象 then
        return self.帮派对象:帮战是否失败()
    end
end

function 接口:帮派创建(名称, 宗旨)
    return self:角色_帮派创建(名称, 宗旨)
end

function 接口:响应帮派(名称)
    return self:角色_响应帮派(名称)
end

function 接口:打开对话(...)
    return self.rpc:打开对话(...)
end

function 接口:确认窗口(...)
    return self.rpc:确认窗口(...)
end

function 接口:输入窗口(...)
    return self.rpc:输入窗口(...)
end

function 接口:灯谜窗口(...)
    return self.rpc:灯谜窗口(...)
end

function 接口:数值输入窗口(...)
    return self.rpc:数值输入窗口(...)
end

function 接口:打开给予窗口(nid)
    return self.rpc:打开给予(nid)
end

function 接口:添加月卡(时效)
    if self.月卡.时效 == nil or os.time() > self.月卡.时效 then
        self.月卡.时效 = os.time() + 时效
    else
        self.月卡.时效 = self.月卡.时效 + 时效
    end
    return true
end

function 接口:月卡快传()
    if self.月卡.时效 == nil or os.time() > self.月卡.时效 or not __config.月卡快传 then
        return false
    end
    return true
end

function 接口:购买窗口(spt, 货币)
    if __脚本[spt] and __脚本[spt].取商品 and __脚本[spt].购买 then
        coroutine.xpcall(function()
            local list = __脚本[spt]:取商品(self.接口)
            if type(list) == 'table' then
                local 校验 = {}
                for i, v in pairs(list) do
                    校验[i] = tostring(v)
                end

                local n = self.银子
                if 货币 then
                    n = self.其它[货币]
                end
                -- if 货币 == "水陆积分" then
                --     n = self.其它.水陆积分
                -- end

                local i, n = self.rpc:购买窗口(n, list)
                local list = __脚本[spt]:取商品(self.接口)
                if 校验[i] == tostring(list[i]) then
                    local r = __脚本[spt]:购买(self.接口, i, n)
                    if type(r) == 'string' then
                        self.rpc:提示窗口(r)
                    end
                else
                    self.rpc:提示窗口('#Y购买失败，商品已经刷新')
                end
            end
        end)
    end
end

function 接口:置交易锁(v)
    self.交易锁 = v == true
    return self.交易锁
end

function 接口:当铺窗口()
    self.rpc:当铺窗口()
end

function 接口:换角色窗口()
    local 外形, 种族, 性别 = self.rpc:换角色窗口()
    return 种族, 性别, 外形
end

function 接口:转生窗口()
    local 种族, 性别, 外形 = self.rpc:转生窗口()
    return 种族, 性别, 外形
end

function 接口:飞升窗口()
    local 种族, 性别, 外形 = self.rpc:飞升窗口()
    return 种族, 性别, 外形
end

function 接口:作坊总管窗口()
    self.rpc:作坊总管窗口()
end

function 接口:取转生记录()
    return self.转生记录
end

function 接口:作坊窗口(nid, t)
    self.rpc:作坊窗口(nid, t)
end

function 接口:提升称谓(r)
    self:修复称谓(r)
    return true
end

function 接口:灌输灵气窗口()
    self.rpc:灌输灵气窗口(self.银子)
end

function 接口:仙器升级窗口()
    self.rpc:仙器升级窗口(self.银子)
end

function 接口:仙器炼化窗口()
    self.rpc:仙器炼化窗口(self.银子)
end

function 接口:仙器重铸窗口()
    self.rpc:仙器重铸窗口(self.银子)
end

function 接口:神兵升级窗口()
    self.rpc:神兵升级窗口(self.银子)
end

function 接口:神兵强化窗口()
    self.rpc:神兵强化窗口(self.银子)
end

function 接口:神兵精炼窗口()
    self.rpc:神兵精炼窗口(self.银子)
end

function 接口:神兵炼化窗口()
    self.rpc:神兵炼化窗口(self.银子)
end

function 接口:装备打造窗口()
    self.rpc:装备打造窗口(self.银子)
end

function 接口:发送系统(...) --71
    __世界:发送系统(...)
end

function 接口:取银子()
    return self.银子
end

function 接口:取师贡()
    return self.师贡
end

function 接口:是否队友(P)
    return self:是否队友(P)
end

function 接口:刷新外形()
    return self:角色_刷新外形()
end

function 接口:符合替身(nid)
    if self.转生 < 1 and not self.是否摆摊 and not self.是否组队 and self.nid ~= nid then
        return true
    end
end

function 接口:遍历队友()
    local k, v
    return function(list)
        k, v = next(list, k)
        if v == self then
            k, v = next(list, k)
        end
        if v then
            return k, v.接口
        end
    end, self.队伍 or {}
end

function 接口:遍历队伍()
    local k, v
    return function(list)
        k, v = next(list, k)
        if v then
            return k, v.接口
        end
    end, self.队伍 or { self }
end

function 接口:取任务(名称)
    local r = self:任务_获取(名称)
    return r and r.接口
end

function 接口:判断等级是否低于2(等级, 转生)
    if type(转生) == 'number' then
        if self.转生 > 转生 then
            return false
        else
            if self.等级 >= 等级 then
                return false
            end
        end
    else
        if type(等级) == 'number' and self.等级 >= 等级 then
            return false
        end
    end
    return true
end

function 接口:判断等级是否低于(等级, 转生, 飞升)
    if type(等级) == 'number' and self.等级 >= 等级 then
        return false
    end
    if type(转生) == 'number' and self.转生 > 转生 then
        return false
    end
    if type(飞升) == 'number' and self.飞升 > 飞升 then
        return false
    end

    return true
end

function 接口:判断等级是否高于(等级, 转生)
    if type(等级) == 'number' and self.等级 <= 等级 then
        return false
    end
    if type(转生) == 'number' and self.转生 < 转生 then
        return false
    end
    return true
end

function 接口:取双倍时间数据()
    if not __双倍时间[self.nid] then
        __双倍时间[self.nid] = 0
    end
    return __双倍时间[self.nid]
end

function 接口:领取双倍时间(n)
    if not __双倍时间[self.nid] then
        __双倍时间[self.nid] = 0
    end
    __双倍时间[self.nid] = __双倍时间[self.nid] + n
    return __双倍时间[self.nid]
end

function 接口:取五倍时间数据()
    if not __五倍时间[self.nid] then
        __五倍时间[self.nid] = 0
    end
    return __五倍时间[self.nid]
end

function 接口:领取五倍时间(n)
    if not __五倍时间[self.nid] then
        __五倍时间[self.nid] = 0
    end
    __五倍时间[self.nid] = __五倍时间[self.nid] + n
    return __五倍时间[self.nid]
end

function 接口:设置关卡倒计时(g, n)
    self.rpc:设置关倒时(g, n)
    if self.是否组队 then
        for _, v in self:遍历队友() do
            coroutine.xpcall(
                function()
                    v.rpc:设置关倒时(g, n)
                end
            )
        end
    end
end

function 接口:取队伍人数()
    if self.是否组队 then
        return #self.队伍
    end
    return 1
end

function 接口:取队伍平均等级()
    local 等级 = 0
    for _, v in self:遍历队伍() do
        等级 = 等级 + v.等级
    end
    等级 = 等级 / #self.队伍
    return math.floor(等级)
end

function 接口:取队伍最高等级()
    local 等级 = self.等级
    for _, v in self:遍历队伍() do
        if v.等级 > 等级 then
            等级 = v.等级
        end
    end
    return 等级
end

function 接口:取队伍最高转生()
    local 转生 = self.转生
    for _, v in self:遍历队伍() do
        if v.转生 > 转生 then
            转生 = v.转生
        end
    end
    return 转生
end

function 接口:添加任务(t, ...)
    if type(t) == 'string' then
        t = __沙盒.生成任务({ 名称 = t }, ...)
    end
    return self:任务_添加(t) and true
end

function 接口:遍历任务()
    -- local k, v
    -- return function(list)
    --     k, v = next(list, k)
    --     if v then
    --         return k, v.接口
    --     end
    -- end, self._任务

    return self:遍历任务()
end

function 接口:遍历召唤()
    return self:遍历召唤()
end

function 接口:取召唤_携带上限()
    local n = self:取召唤兽数量()
    return self.召唤兽携带上限 >= n
end

function 接口:取召唤兽_按原名(name)
    local list = {}
    for k, v in self:遍历召唤() do
        if v.原名 == name then
            table.insert(list, { 名称 = v.名称, 等级 = v.等级, 转生 = v.转生, nid = v.nid })
        end
    end
    return list
end

function 接口:取召唤兽_按nid(nid)
    for k, v in self:遍历召唤() do
        if v.nid == nid then
            return v.接口
        end
    end
end

function 接口:住店()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
end

function 接口:超级巫医()
    for k, v in self:遍历召唤() do
        v:超级巫医()
    end
end

function 接口:取巫医消耗()
    local yzxh = 0
    for k, v in self:遍历召唤() do
        yzxh = yzxh + v:取巫医消耗()
    end
    return yzxh
end

function 接口:取玩家(nid)
    return __玩家[nid]
end

function 接口:打开宠物领养窗口()
    return self.rpc:打开宠物领养()
end

function 接口:领养时间宠(n)
    local r = require('数据库/宠物库')[n]

    if not next(self.宠物) then
        self:宠物_添加(require('对象/宠物') { 名称 = r.name, 外形 = r.外形 })
        return 1
    else
        if self.rpc:确认窗口('是否确定替换当前时间宠？') then
            local _, p = next(self.宠物)
            p.名称 = r.name
            p.外形 = r.外形
            return 2
        end
    end
    return false
end

function 接口:改名(v)
    if self.是否战斗 or self.是否摆摊 or type(v) ~= 'string' then
        return
    end
    self.名称 = v
    self.rpc:切换名称(self.nid, v)
    self.rpn:切换名称(self.nid, v)
    self:存档()
    return true
end

function 接口:增减气血(v, wts) -- 无提示
    if type(v) == 'number' then
        self.气血 = self.气血 + math.floor(v)
        if not wts then
            self.rpc:添加特效(self.nid, 'add_hp')
            self.rpn:添加特效(self.nid, 'add_hp')
        end
        if self.气血 > self.最大气血 then
            self.气血 = self.最大气血
        end
        return self.气血
    end
end

function 接口:增减魔法(v, wts)
    if type(v) == 'number' then
        self.魔法 = self.魔法 + math.floor(v)
        if not wts then
            self.rpc:添加特效(self.nid, 'add_mp')
            self.rpn:添加特效(self.nid, 'add_mp')
        end
        if self.魔法 > self.最大魔法 then
            self.魔法 = self.最大魔法
        end
        return self.魔法
    end
end

function 接口:双加(a, b)
    if type(a) == 'number' and type(b) == 'number' then
        self.气血 = self.气血 + math.floor(a)
        self.魔法 = self.魔法 + math.floor(b)
        if self.魔法 > self.最大魔法 then
            self.魔法 = self.最大魔法
        end

        if self.气血 > self.最大气血 then
            self.气血 = self.最大气血
        end


        return self.魔法
    end
end

function 接口:添加体力(n)
    return self:添加体力(n)
end

function 接口:取技能数量()
    local n = 0
    for _, jn in self:遍历技能() do
        n = n + 1
    end
    return n
end

function 接口:取技能是否存在(s)
    for _, v in self:遍历技能() do
        if v.名称 == s then
            return true
        end
    end
    return false
end

function 接口:取技能是否满熟练(s)
    for _, v in self:遍历技能() do
        if v.名称 == s then
            if v.熟练度 >= v.熟练度上限 then
                return true
            end
        end
    end
    return false
end

function 接口:添加技能(name, m)
    local 通过
    local t = require('数据库/角色').基本信息[self.种族]
    local jnk = require('数据库/角色').门派技能
    if t then
        for _, mp in ipairs(t.门派) do
            if jnk[mp] then
                通过 = true
            end
        end
    end
    if 通过 then
        return self:添加技能(name, m)
    end
end

function 接口:指定阶数技能添加熟练(jn, n) --指定阶数添加
    for k, v in self:遍历技能() do
        if v.阶段 == jn then
            v:添加熟练度(math.floor(n))
        end
    end
end

function 接口:指定名称技能添加熟练(jn, n) --指定名称添加
    for k, v in self:遍历技能() do
        if v.名称 == jn then
            v:添加熟练度(math.floor(n))
        end
    end
end

function 接口:所有技能添加熟练(n) --所有技能添加
    for k, v in self:遍历技能() do
        v:添加熟练度(math.floor(n))
    end
end

function 接口:添加法术熟练(熟练) --所有技能随机
    if type(熟练) == 'number' then
        local kts = {}
        for k, v in self:遍历技能() do
            if v.熟练度 < v.熟练度上限 then
                table.insert(kts, k)
            end
        end
        if #kts > 0 then
            local k = kts[math.random(#kts)]
            self.技能[k]:添加熟练度(熟练)
            self.刷新的属性.技能 = true
            return self.技能[k].名称
        else
            self.rpc:提示窗口('#Y 你所有法术熟练度已经达到上限，无法食用！')
        end
    end
    return false
end

function 接口:取地图(id)
    return __地图[id] and __地图[id].接口
end

function 接口:取当前地图()
    return self.当前地图.接口
end

function 接口:取帮派地图()
    if not self.帮派对象 then
        return
    end
    return self.帮派对象:取地图()
end

function 接口:取随机地图(t)
    if type(t) ~= 'table' then
        return
    end
    local map
    local n = 0
    repeat
        map = __地图[t[math.random(#t)]]
        n = n + 1
    until map or n > 100
    return map and map.接口
end

function 接口:切换地图(mid, x, y)
    local map = __地图[mid]
    if map then
        x = math.floor(x * 20)
        y = math.floor((map.高度 - y) * 20)
        coroutine.xpcall(
            function()
                self:移动_切换地图(map, x, y)
            end
        )
    end
end

function 接口:切换地图2(map, x, y)
    if map then
        x = math.floor(x * 20)
        y = math.floor((map.高度 - y) * 20)
        coroutine.xpcall(
            function()
                self:移动_切换地图(map, x, y)
            end
        )
    end
end

function 接口:进入副本(mid, x, y)
    local map = __副本地图[mid]
    if map then
        x = math.floor(x * 20)
        y = math.floor((map.高度 - y) * 20)
        coroutine.xpcall(
            function()
                self:移动_切换地图(map, x, y)
            end
        )
    end
end

local _可双倍 = {
    抓鬼 = true,
    鬼王 = true,
    天庭 = true,
    修罗 = true,
    师门 = true,
    种族 = true,
    野外 = true
}
local _不可加成 = {
    人参果 = true,
    人参果王 = true,
    超级人参果王 = true,
    测试人参果王 = true
}
function 接口:添加声望(n, 来源)
    self.声望 = math.floor(self.声望 + n)
    self.最大声望 = math.floor(self.最大声望 + n)
end

function 接口:添加等级()
    self.等级 = self.等级 + 1
    self.根骨 = self.根骨 + 1
    self.灵性 = self.灵性 + 1
    self.力量 = self.力量 + 1
    self.敏捷 = self.敏捷 + 1
    self.潜力 = self.潜力 + 4
    for k, v in self:遍历召唤() do
        v:添加亲密度2()
    end
    self.最大经验 = self:取升级经验()
    self:刷新属性(1)
    self.rpc:添加特效(self.nid, 'level_up')
    self.rpn:添加特效(self.nid, 'level_up')
end

function 接口:刷新属性(n)
    self:刷新属性(n)
end

function 接口:地图在线奖励()
    return __地图在线奖励
end

function 接口:取经验加成(来源)
    local 倍率 = 1
    if self.月卡.时效 and os.time() < self.月卡.时效 then
        倍率 = 倍率 + 0.05
    end
    if 来源 then
        if _可双倍[来源] then
            local r = self:任务_获取('双倍时间')
            if r and not r.冻结 then
                倍率 = 倍率 + 1
            end
            r = self:任务_获取('祝福券')
            if r and not r.冻结 then
                倍率 = 倍率 + 2
            end
        elseif 来源 == '降魔' then
            local r = self:任务_获取('五倍时间')
            if r and not r.冻结 then
                倍率 = 倍率 + 5
            end
        end
    end
    return 倍率
end

function 接口:添加法宝经验(n, 来源, 上限)
    if type(n) ~= 'number' then
        return
    end
    return self:法宝_添加经验(n, 上限)
end

function 接口:添加法宝(T)
    return self:法宝_添加(T)
end

function 接口:取法宝是否存在(name)
    local r = false
    for k, v in self:遍历法宝() do
        if v.名称 == name then
            r = true
            break
        end
    end
    return r
end

function 接口:添加任务经验(n, 来源)
    n = n * 接口.取经验加成(self, 来源)
    接口.添加经验(self, n)
    local r = 接口.取参战召唤兽(self)
    local kr = 接口.取枯荣丹召唤(self)

    if kr then
        kr:添加经验(n * 1.5)
        kr:添加内丹经验(n * 1.5)
    elseif r then
        r:添加经验(n * 1.5)
        r:添加内丹经验(n * 1.5)
    end
end

function 接口:添加任务经验_单角色(n, 来源)
    n = n * 接口.取经验加成(self, 来源)
    接口.添加经验(self, n)
end

function 接口:添加任务经验_单召唤(n, 来源)
    n = n * 接口.取经验加成(self, 来源)
    local r = 接口.取参战召唤兽(self)
    local kr = 接口.取枯荣丹召唤(self)

    if kr then
        kr:添加经验(n * 1.5)
        kr:添加内丹经验(n * 1.5)
    elseif r then
        r:添加经验(n * 1.5)
        r:添加内丹经验(n * 1.5)
    end
end

function 接口:取枯荣丹召唤()
    local r = self:任务_获取("枯荣丹")
    if r then
        return __召唤[r.对象id] and __召唤[r.对象id].接口
    end
end

function 接口:添加月卡()
    if self.月卡数据.时效 == nil or os.time() - self.月卡数据.时效 > 0 then
        self.月卡数据.时效 = os.time() + 3600 * 24 * 30
    else
        self.月卡数据.时效 = self.月卡数据.时效 + 3600 * 24 * 30
    end
    return true
end

function 接口:添加经验(n)
    self.经验 = math.floor(self.经验 + n)
    if self:取等级上限() then
        return false
    end
    while self.经验 >= self.最大经验 and not self:取等级上限() do
        self.经验 = self.经验 - self.最大经验
        接口.添加等级(self)
        self.task:任务升级事件(self.接口)
    end

    self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y点经验')
    return true
end

function 接口:扣除经验(n)
    self.经验 = math.floor(self.经验 - n)
    if self.经验 < 0 then
        self.经验 = 0
    end


    self.rpc:提示窗口('#Y你被扣除了#R' .. n .. '#Y点经验')
    return true
end

function 接口:添加参战召唤兽亲密度(n)
    local r = 接口.取参战召唤兽(self)
    if r then
        r:添加亲密度(n, 1)
    end
end

function 接口:添加参战召唤兽经验(n)
    local r = 接口.取参战召唤兽(self)
    if r then
        r:添加经验(n * 1.5)
        r:添加内丹经验(n * 1.5)
    end
end

function 接口:取参战召唤兽()
    if self.参战召唤 then
        return self.参战召唤.接口
    end
end

function 接口:取当前时间宠()
    if self.当前宠物 then
        return self.当前宠物
    end
end

function 接口:取时间宠等级()
    if self.当前宠物 then
        return self.当前宠物.等级
    end
    return 0
end

function 接口:踢下线()
    self:踢下线()
end

function 接口:角色转移(账号, 密码, 安全码)
    local user = __存档.验证账号(账号, GGF.MD5(密码))
    if user then
        if __存档.存在角色数量(user.id) >= 6 then
            return "#Y目标账号角色数量已满！"
        end
        local r = __存档.转移角色(user.id, self.nid, self)
        if r == true then
            self.uid = user.id
        end
        return r
    else
        return "#Y目标账号密码错误！"
    end
end

function 接口:添加坐骑(Z)
    return self:坐骑_添加(Z)
end

function 接口:取乘骑坐骑()
    if self.当前坐骑 then
        return self.当前坐骑.接口
    end
end

function 接口:添加坐骑经验(n)
    if self.当前坐骑 then
        self.当前坐骑:获得经验(n)
    end
end

function 接口:取坐骑是否存在(n)
    for _, v in self:遍历坐骑() do
        if v.几座 == n then
            return true
        end
    end
end

function 接口:取坐骑是否存在2(n, z)
    for _, v in self:遍历坐骑() do
        if v.几座 == n and v.种族 == z then
            return true
        end
    end
end

function 接口:是否佩戴装备()
    for k, v in pairs(self.装备) do
        return true
    end
end

function 接口:脱光佩戴装备()
    for k, v in pairs(self.装备) do
        self.装备[k] = nil
    end
end

local _称谓需求 = {
    { '三界贤君' },
    { '齐天妖王' },
    { '九天圣佛' },
    { '阴都大帝' },
}
local _转生等级需求 = { 102, 122, 142, 180 }


local _转生称谓需求 = { 10, 10, 14 }


function 接口:转生任务添加检测(性别)
    if self.转生 >= 3 then
        return "最高3转！"
    end
    if self.等级 < _转生等级需求[self.转生 + 1] then
        return "等级未达到转生要求！"
    end
    for k, v in self:遍历任务() do
        if v.禁止转生 then
            return "请先完成任务栏任务！"
        end
    end
    if self.是否组队 then
        return "请先离队！"
    end
    if 性别 and self.配偶 and 性别 ~= self.性别 then
        return "已结婚的玩家在转生的时候不能改变性别！"
    end
    local n = _转生称谓需求[self.转生 + 1]
    if n then
        if not self:剧情称谓是否存在(n) then
            return "请先获得" .. n .. "级别剧情称谓"
        end
    end

    if not self:转生技能检测() then
        return "所有法术满熟练才可以转生呢"
    end
    if self.经验 < 0 then
        return "必须把经验补为正数或通过降级弥补经验值"
    end
    return true
end

function 接口:转生条件检测(性别)
    if self.转生 >= 3 then
        return "最高3转！"
    end
    if self.等级 < _转生等级需求[self.转生 + 1] then
        return "等级未达到转生要求！"
    end

    if 接口.是否佩戴装备(self) then
        return "请先卸下人物装备！"
    end
    for k, v in self:遍历任务() do
        if v.禁止转生 then
            return "请先完成任务栏任务！"
        end
    end
    if self.是否组队 then
        return "请先离队！"
    end
    if 性别 and self.配偶 and 性别 ~= self.性别 then
        return "已结婚的玩家在转生的时候不能改变性别！"
    end
    local n = _转生称谓需求[self.转生 + 1]
    if n then
        if not self:剧情称谓是否存在(n) then
            return "请先获得" .. n .. "级别剧情称谓"
        end
    end

    if not self:转生技能检测() then
        return "至少有一种技能学习到第五阶并且满熟练度"
    end

    -- if self.当前宠物 then
    --     if self.当前宠物.等级 < 10 then
    --         return "先将时间宠提升至10级"
    --     end
    -- end

    if self.经验 < 0 then
        return "必须把经验补为正数或通过降级弥补经验值"
    end
end

function 接口:飞升条件(性别)
    if self.飞升 == 1 then
        self.rpc:常规提示("你已经飞升过了")
        return false
    end
    if 接口.是否佩戴装备(self) then
        self.rpc:常规提示("请先卸下人物装备！")
        return false
    end
    if 性别 and self.配偶 and 性别 ~= self.性别 then
        self.rpc:常规提示("已经有配偶的无法改变性别！")
        return false
    end
    if not self:飞升技能检测() then
        self.rpc:常规提示("飞升要求满技能满熟练度")
        return false
    end
    return true
end

function 接口:飞升条件检测(性别)
    if 性别 and self.配偶 and 性别 ~= self.性别 then
        return "已结婚的玩家在转生的时候不能改变性别！"
    end
    if not self:飞升技能检测() then
        return "飞升要求满技能满熟练度"
    end
end

function 接口:换角色检测(性别)
    if 接口.是否佩戴装备(self) then
        return "请先卸下人物装备！"
    end
    if self.是否组队 then
        return "请先离队！"
    end
    if 性别 and self.配偶 and 性别 ~= self.性别 then
        return "已结婚的玩家不能改变性别！"
    end
end

local 转生dj = { 15, 15, 60 }


local _取门派抗性 = {
    方寸山 = "抗昏睡",
    化生寺 = "抗混乱",
    程府 = "抗封印",
    女儿村 = "抗毒伤害", -- 抗中毒伤害

    天宫 = "抗雷",
    龙宫 = "抗水",
    五庄观 = "抗风",
    普陀山 = "抗火",

    狮驼岭 = "SP成长",
    盘丝洞 = "物理吸收", -- 抗震慑
    地府 = "MP成长",
    魔王寨 = "HP成长",

    白骨洞 = "抗鬼火",
    阴都 = "抗遗忘",
    三尸派 = "抗三尸虫",
    兰若寺 = "反震率",
}

local _取门派多抗性 = {
    物理吸收 = "抗震慑",
    抗毒伤害 = "抗中毒",
    反震率 = "反震程度",
}

function 接口:转生处理(种族, 性别, 外形)
    if 接口.转生条件检测(self) then
        return
    end
    local 旧门派 = require('数据库/角色').基本信息[self.原形].门派
    local t = require('数据库/角色').基本信息[外形]
    if not t then
        return
    end
    local jl = { 种族 = self.种族 * 1000 + self.性别 }
    local kx
    local xzxs
    for _, mp in pairs(旧门派) do
        kx = _取门派抗性[mp]
        xzxs = self:取修正系数(mp, self.转生)
        jl[kx] = xzxs
        if _取门派多抗性[kx] then
            jl[_取门派多抗性[kx]] = xzxs
        end
    end
    table.insert(self.转生记录, jl)
    if self.种族 ~= t.种族 then
        self:剧情称谓转换(self.种族, t.种族)
    end
    self.转生 = self.转生 + 1
    self.等级 = 转生dj[self.转生]
    self.经验 = 0
    self.外形 = 外形
    self.头像 = 外形
    self.原形 = 外形
    self.武器 = nil
    self.种族 = t.种族
    self.性别 = t.性别
    -- self:清空技能()
    local 新门派 = t.门派
    local _门派技能 = require('数据库/角色').门派技能
    local 旧技能 = {}
    for _, jn in self:遍历技能() do
        if jn.阶段 then
            旧技能[jn.名称] = jn
        end
    end

    for ji, jmp in ipairs(旧门派) do
        for i, mc in ipairs(_门派技能[jmp]) do
            if 旧技能[mc] then
                local xmp = 新门派[ji]
                --旧技能[mc].名称 = _门派技能[xmp][i]
                旧技能[mc]:转换(_门派技能[xmp][i])
                旧技能[mc]:刷新熟练度上限(self)
            end
        end
    end
    if self.当前宠物 then
        self.当前宠物:转生()
    end
    self:角色_人物洗点()
    self:角色_取名称颜色()
end

function 接口:飞升处理(种族, 性别, 外形)
    if not 接口.飞升条件(self) then
        return
    end
    local t = require('数据库/角色').基本信息[外形]
    if not t then
        return
    end
    local 旧门派 = require('数据库/角色').基本信息[self.原形].门派
    local jl = { 种族 = self.种族 * 1000 + self.性别 }
    local kx
    local xzxs
    for _, mp in pairs(旧门派) do
        kx = _取门派抗性[mp]
        xzxs = self:取修正系数(mp, self.转生)
        jl[kx] = xzxs
        if _取门派多抗性[kx] then
            jl[_取门派多抗性[kx]] = xzxs
        end
    end
    table.insert(self.转生记录, jl)
    if self.种族 ~= t.种族 then
        self:剧情称谓转换(self.种族, t.种族)
    end

    self.飞升 = 1 ---这里屏蔽了
    self.等级 = 120
    self.经验 = 0
    self.外形 = 外形
    self.头像 = 外形
    self.原形 = 外形
    self.武器 = nil
    self.种族 = t.种族
    self.性别 = t.性别
    -- self:清空技能()
    local 新门派 = t.门派
    local _门派技能 = require('数据库/角色').门派技能
    local 旧技能 = {}
    for _, jn in self:遍历技能() do
        if jn.阶段 then
            旧技能[jn.名称] = jn
        end
    end
    for ji, jmp in ipairs(旧门派) do
        for i, mc in ipairs(_门派技能[jmp]) do
            if 旧技能[mc] then
                local xmp = 新门派[ji]
                --旧技能[mc].名称 = _门派技能[xmp][i]
                旧技能[mc]:转换(_门派技能[xmp][i])
                旧技能[mc]:刷新熟练度上限(self)
            end
        end
    end
    self:角色_人物洗点()
    self:角色_取名称颜色()
    return true
end

function 接口:添加指定种族全部技能(种族, n)
    local t = require('数据库/角色').基本信息[种族]
    local jnk = require('数据库/角色').门派技能

    if t then
        for _, mp in ipairs(t.门派) do
            if jnk[mp] then
                for _, jn in ipairs(jnk[mp]) do
                    self:添加技能(jn, n)
                end
            end
        end
    end
end

function 接口:添加全部技能(n)
    local t = require('数据库/角色').基本信息[self.原形 or self.外形]
    local jnk = require('数据库/角色').门派技能

    if t then
        for _, mp in ipairs(t.门派) do
            if jnk[mp] then
                for _, jn in ipairs(jnk[mp]) do
                    self:添加技能(jn, n)
                end
            end
        end
    end
end

function 接口:添加经验_时间宠(n)
    if self.当前宠物 then
        return self.当前宠物:添加经验(n)
    end
end

function 接口:人物洗点()
    if 接口.是否佩戴装备(self) then
        return "#Y请先卸下人物装备！"
    end

    self:角色_人物洗点()
    return true
end

function 接口:换角色处理(种族, 性别, 外形)
    if self.银子 + self.师贡 < 5000000 then
        self.rpc:常规提示("你身上的银两不足500W两！")
        return
    end
    self:角色_扣除银子(5000000, "换角色", true)
    local 旧门派 = require('数据库/角色').基本信息[self.原形].门派
    local t = require('数据库/角色').基本信息[外形]
    if self.种族 ~= t.种族 then
        self:剧情称谓转换(self.种族, t.种族)
    end

    self.外形 = 外形
    self.头像 = 外形
    self.原形 = 外形
    self.种族 = t.种族
    self.性别 = t.性别
    self.门派 = t.门派
    self.武器 = nil
    local 新门派 = t.门派
    local _门派技能 = require('数据库/角色').门派技能
    local 旧技能 = {}
    for _, jn in self:遍历技能() do
        if jn.阶段 then
            旧技能[jn.名称] = jn
        end
    end

    for ji, jmp in ipairs(旧门派) do
        for i, mc in ipairs(_门派技能[jmp]) do
            if 旧技能[mc] then
                local xmp = 新门派[ji]
                --旧技能[mc].名称 = _门派技能[xmp][i]
                旧技能[mc]:转换(_门派技能[xmp][i])
                旧技能[mc]:刷新熟练度上限(self)
            end
        end
    end


    self:角色_人物洗点()
    self:刷新属性()
end

function 接口:更新称谓剧情(n)
    self.称谓剧情 = n
end

function 接口:添加称谓(s)
    return self:角色_添加称谓(s)
end

function 接口:删除称谓(s)
    return self:角色_删除称谓(s)
end

function 接口:添加物品(t)
    local r = self:物品_添加(t)
    if r then
        for k, v in pairs(t) do
            if v.数据.数量 and v.数据.数量 > 1 then
                self.rpc:提示窗口('#Y你获得了#G' .. v.数据.名称 .. '*' .. v.数据.数量)
            else
                self.rpc:提示窗口('#Y你获得了#G' .. (v.数据.原名 or v.数据.名称))
            end
        end
    end
    return r
end

function 接口:物品检查添加(t)
    return self:物品_检查添加(t)
end

function 接口:添加物品_无提示(t)
    local r = self:物品_添加(t)
    return r
end

function 接口:添加召唤(t)
    local r = self:召唤_添加(t)
    if r then
        self.rpc:提示窗口('#Y你获得了#G' .. t.名称)
    else
        self.rpc:提示窗口('#Y已达到携带上限')
    end
    return r
end

function 接口:添加孩子(t)
    local r = self:孩子_添加(t)
    if r then
        self.rpc:提示窗口('#Y你获得了#G' .. t.名称)
    else
        self.rpc:提示窗口('#Y已达到携带上限')
    end
    return r
end

function 接口:出家孩子()
    if self.是否战斗 or self.是否摆摊 then
        return '#当前状态下无法进行此操作'
    end

    if not self.参战孩子 then --判断是否有孩子参战,出家当前孩子
        return '#请将要出家的孩子设置为参战状态'
    end

    return self:孩子_出家()
end

function 接口:取参战孩子()
    if self.参战孩子 then
        return self.参战孩子.接口
    end
end

function 接口:删除物品(name, n)
    if not n then
        n = 1
    end
    local r = self:物品_获取(name)
    if r then
        if r.数量 >= n then
            r:减少(n)
            return true
        end
    end
end

function 接口:取包裹空位(p)
    return self:物品_查找空位(p)
end

function 接口:离开队伍()
    self:角色_离开队伍()
end

function 接口:取物品是否存在(name)
    return self:物品_获取(name)
end

function 接口:指定取物品是否存在(name, sl)
    return self:指定物品_获取(name, sl)
end

function 接口:取活动限制次数(name)
    if __活动限制[self.nid] == nil then
        __活动限制[self.nid] = {}
    end
    if __活动限制[self.nid][name] == nil then
        __活动限制[self.nid][name] = 0
    end
    return __活动限制[self.nid][name]
end

function 接口:增加活动限制次数(name)
    if __活动限制[self.nid] == nil then
        __活动限制[self.nid] = {}
    end
    if __活动限制[self.nid][name] == nil then
        __活动限制[self.nid][name] = 0
    end
    __活动限制[self.nid][name] = __活动限制[self.nid][name] + 1
end

function 接口:取周限次数(name)
    if __周限数据[self.nid] == nil then
        __周限数据[self.nid] = {}
    end
    if __周限数据[self.nid][name] == nil then
        __周限数据[self.nid][name] = 0
    end
    return __周限数据[self.nid][name]
end

function 接口:增加周限次数(name)
    if __周限数据[self.nid] == nil then
        __周限数据[self.nid] = {}
    end
    if __周限数据[self.nid][name] == nil then
        __周限数据[self.nid][name] = 0
    end
    __周限数据[self.nid][name] = __周限数据[self.nid][name] + 1
end

function 接口:添加银子(n, 来源, wts)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    来源 = 来源 and 来源 or "默认"
    self.刷新的属性.银子 = true
    self.银子 = self.银子 + n
    if not wts then
        self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y两银子')
    end
    self:日志_银子记录('【添加银子】获得%s银子 来源:%s 现有银子:%s', n, 来源, self.银子)
end

function 接口:添加师贡(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.刷新的属性.师贡 = true
    self.师贡 = self.师贡 + n
    self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y点师贡')
end

function 接口:处理补偿()
    self:处理补偿()
end

function 接口:扣除师贡(n, 来源, 银子, wts)
    return self:角色_扣除师贡(n, 来源, 银子, wts)
end

function 接口:添加水陆积分(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    return self:添加水陆积分(n)
end

function 接口:添加帮派成就(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    if not self.帮派对象 then
        self.rpc:提示窗口('#Y你还没有加入任何帮派')
        return
    end

    self.帮派成就 = self.帮派成就 + n
    self.帮派对象:同步成员成就(self.nid, self.帮派成就)
    self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y点帮派成就')
    return true
end

function 接口:添加帮派建设度(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    if self.帮派对象 then
        self.帮派对象:添加建设度(n)
    end
end

function 接口:扣除银子(n, 来源, 师贡, 数量, 物品, wts)
    return self:角色_扣除银子(n, 来源, 师贡, 数量, 物品, wts)
end

function 接口:扣除水陆积分(n)
    return self:扣除水陆积分(n)
end

function 接口:扣除指定积分(n, 类型)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    if self.其它[类型] < n then
        return
    end
    self.其它[类型] = self.其它[类型] - n
    return self.其它[类型]
end

function 接口:添加指定积分(n, 类型)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.其它[类型] = self.其它[类型] + n
    self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y' .. 类型)
    return self.其它[类型]
end

function 接口:扣除体力(n)
    return self:角色_扣除体力(n)
end

function 接口:修改VIP等级(n)
    self.VIP = n
    return self.VIP
end

function 接口:添加仙玉(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end

    self.仙玉 = self.仙玉 + n
    self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y点积分')
    return self.仙玉
end

local _单笔范围 = {
    [1000] = "单笔礼包100",
    [5000] = "单笔礼包500",
    [10000] = "单笔礼包1000",
    [20000] = "单笔礼包2000",
    [30000] = "单笔礼包3000",
    [50000] = "单笔礼包5000"
}
local _累计范围 = {
    { 1000, "累计礼包100" },
    { 2000, "累计礼包200" },
    { 5000, "累计礼包500" },
    { 10000, "累计礼包1000" },
    { 20000, "累计礼包2000" },
    { 30000, "累计礼包3000" },
    { 50000, "累计礼包5000" },
}



--不带鬼
local 新宝石名称 = {
    { '赤焰石', "加强加防法术", "加强雷", "加强震慑", "加强风", "加强加攻法术", "加强火", "加强封印", "加强水", "加强混乱", "加强昏睡" },
    { '紫烟石', "加成攻击", "风系狂暴几率", "加强混乱", "雷系狂暴几率", "加强封印", "水系狂暴几率", "加强昏睡", "火系狂暴几率", "加强毒" },
    { '孔雀石', "忽视抗火", "忽视抗封", "忽视抗毒", "忽视抗风", "忽视抗混", "附加攻击", "忽视抗雷", "忽视抗睡", "忽视抗水" }, --选一个
    { '落星石', "抗雷", "抗火", "抗水", "抗风" },
    { '沐阳石', "抗雷", "抗火", "抗水", "物理吸收", "抗风", "抗昏睡", "抗混乱", "抗封印" },
    { '芙蓉石', "物理吸收", "抗昏睡", "抗混乱", "抗封印" },
    { '琉璃石', "附加魔法", "附加气血", "速度" },
    { '寒山石', "强力克火", "强力克水", "强力克土", "强力克金", "强力克木" },
}
--  屏蔽上面 注意下面同样要屏蔽
local 新宝石属性 = {
    加成攻击 = 2.2,
    抗昏睡 = 1,
    抗混乱 = 1,
    抗封印 = 1,
    加强封印 = 1.2,
    加强混乱 = 1.2,
    加强昏睡 = 1.2,
    加强震慑 = 1.2,
    -- 加强遗忘=1.2,
    加强加攻法术 = 1.5,
    加强加防法术 = 1.5,
    -- 加强魅惑=2.4,
    加强雷 = 2.8,
    加强风 = 2.8,
    加强火 = 2.8,
    加强水 = 2.8,
    加强鬼火 = 2.8,
    水系狂暴几率 = 1.2,
    火系狂暴几率 = 1.2,
    雷系狂暴几率 = 1.2,
    风系狂暴几率 = 1.2,
    -- 鬼火狂暴几率=1.2,
    混乱暴击几率 = 1.2,
    昏睡暴击几率 = 1.2,
    封印暴击几率 = 1.2,
    -- 遗忘暴击几率=1.2,
    毒法暴击几率 = 1.2,
    加攻暴击几率 = 1.2,
    加盘暴击几率 = 1.2,
    震慑暴击几率 = 1.2,
    -- 三尸虫狂暴几率=1.5,
    -- 魅惑暴击几率=1.5,
    -- 忽视抗遗忘=0.6,
    -- 忽视抗鬼火=1.6,
    -- 加强三尸虫=384,
    加强毒伤害 = 2.8,
    加强毒 = 2.8,
    附加攻击 = 2000,
    忽视抗水 = 1.6,
    忽视抗火 = 1.6,
    忽视抗风 = 1.6,
    忽视抗雷 = 1.6,
    忽视抗鬼火 = 1.6,
    忽视抗封 = 0.6,
    忽视抗混 = 0.6,
    忽视抗睡 = 0.6,
    忽视抗毒 = 1.6,
    -- 忽视遗忘=0.6,
    忽视抗震慑 = 0.8,
    抗混上限 = 0.6,
    抗冰上限 = 0.6,
    抗睡上限 = 0.6,
    抗毒上限 = 0.6,
    抗雷 = 1.6,
    抗水 = 1.6,
    抗风 = 1.6,
    抗火 = 1.6,
    物理吸收 = 2.5,
    抗水法狂暴率 = 1.5,
    抗火法狂暴率 = 1.5,
    抗雷法狂暴率 = 1.5,
    抗风法狂暴率 = 1.5,
    -- 抗鬼火=1.6,
    -- 抗遗忘上限=0.6,
    -- 抗鬼火狂暴率=1.5,
    -- 抗三尸虫=240,
    附加魔法 = 2000,
    附加气血 = 4000,
    速度 = 8.5,
    -- 速度= -7,
    加强金箍 = 1.5,
    加强情网 = 1.5,
    抗情网 = 1.5,
    抗金箍 = 1.5,
    抵御强克效果 = 2,
    强力克水 = 4.5,
    强力克火 = 4.5,
    强力克金 = 4.5,
    强力克土 = 4.5,
    强力克木 = 4.5,
}
if __config.种族 == 4 or __config.种族 == 4.1 then
    -- 带鬼
    新宝石名称 = {
        { '赤焰石', "加强加防法术", "加强雷", "加强遗忘", "加强震慑", "加强风", "加强鬼火", "加强加攻法术", "加强火", "加强封印", "加强水", "加强魅惑", "加强混乱", "加强昏睡" },
        { '紫烟石', "风系狂暴几率", "加强混乱", "三尸虫狂暴几率", "雷系狂暴几率", "加强封印", "加强魅惑", "水系狂暴几率", "加强昏睡", "加强震慑", "火系狂暴几率", "加强遗忘", "加成攻击", "鬼火狂暴几率", "加强毒", "加强加防法术" },
        { '孔雀石', "加强三尸虫", "忽视抗火", "忽视抗封", "加强毒伤害", "忽视抗风", "忽视抗混", "附加攻击", "忽视抗雷", "忽视抗睡", "忽视抗水", "忽视抗鬼火", "忽视抗遗忘" },
        { '落星石', "抗混上限", "抗冰上限", "抗睡上限", "抗毒上限" }, --这里没抗性上线需要添加
        { '沐阳石', "抗雷", "抗火", "抗水", "物理吸收", "抗风", "抗风法狂暴率", "抗火法狂暴率", "抗水法狂暴率", "抗昏睡", "抗混乱", "抗封印" }, --,"抗昏睡","抗混乱","抗封印"
        { '芙蓉石', "抗鬼火", "抗鬼火狂暴率", "抗三尸虫", "抗遗忘上限", "物理吸收", "抗昏睡", "抗混乱", "抗封印" }, --,"抗昏睡","抗混乱","抗封印"
        { '琉璃石', "附加魔法", "附加气血", "速度" }, -- 第一个速度是正  第二个速度是负
        { '寒山石', "抗情网", "强力克火", "强力克水", "强力克土", "抗金箍", "强力克金", "强力克木", "抵御强克效果" }, --加强情网 加强金箍
    }
    新宝石属性 = {
        加成攻击 = 2.2,
        抗昏睡 = 1,
        抗混乱 = 1,
        抗封印 = 1,
        加强封印 = 1.2,
        加强混乱 = 1.2,
        加强昏睡 = 1.2,
        加强震慑 = 1.2,
        加强遗忘 = 1.2,
        加强加攻法术 = 1.5,
        加强加防法术 = 1.5,
        加强魅惑 = 2.4,
        加强雷 = 2.8,
        加强风 = 2.8,
        加强火 = 2.8,
        加强水 = 2.8,
        加强鬼火 = 2.8,
        水系狂暴几率 = 1.2,
        火系狂暴几率 = 1.2,
        雷系狂暴几率 = 1.2,
        风系狂暴几率 = 1.2,
        鬼火狂暴几率 = 1.2,
        混乱暴击几率 = 1.2,
        昏睡暴击几率 = 1.2,
        封印暴击几率 = 1.2,
        遗忘暴击几率 = 1.2,
        毒法暴击几率 = 1.2,
        加攻暴击几率 = 1.2,
        加盘暴击几率 = 1.2,
        震慑暴击几率 = 1.2,
        三尸虫狂暴几率 = 1.5,
        魅惑暴击几率 = 1.5,
        忽视抗遗忘 = 0.6,
        加强三尸虫 = 384,
        加强毒伤害 = 2.8,
        加强毒 = 2.8,
        附加攻击 = 2000,
        忽视抗水 = 1.6,
        忽视抗火 = 1.6,
        忽视抗风 = 1.6,
        忽视抗雷 = 1.6,
        忽视抗鬼火 = 1.6,
        忽视抗封 = 0.6,
        忽视抗混 = 0.6,
        忽视抗睡 = 0.6,
        忽视抗毒 = 1.6,
        忽视遗忘 = 0.6,
        忽视抗震慑 = 0.8,
        抗混上限 = 0.6,
        抗冰上限 = 0.6,
        抗睡上限 = 0.6,
        抗毒上限 = 0.6,
        抗雷 = 1.6,
        抗水 = 1.6,
        抗风 = 1.6,
        抗火 = 1.6,
        物理吸收 = 2.5,
        抗水法狂暴率 = 1.5,
        抗火法狂暴率 = 1.5,
        抗雷法狂暴率 = 1.5,
        抗风法狂暴率 = 1.5,
        抗鬼火 = 1.6,
        抗遗忘上限 = 0.6,
        抗鬼火狂暴率 = 1.5,
        抗三尸虫 = 240,
        附加魔法 = 2000,
        附加气血 = 4000,
        速度 = 8.5,
        速度 = -7,
        加强金箍 = 1.5,
        加强情网 = 1.5,
        抗情网 = 1.5,
        抗金箍 = 1.5,
        抵御强克效果 = 2,
        强力克水 = 4.5,
        强力克火 = 4.5,
        强力克金 = 4.5,
        强力克土 = 4.5,
        强力克木 = 4.5,
    }
end

-- 继续


-- local 几率表 = {100,100,100,55,55,65,75,85,95,100} --合成成功几率

function 接口:随机新宝石(等级, 鉴定)
    if math.random(100) <= 10 and 等级 >= 4 and not 鉴定 then --购买出现 奇异石的概率
        local 名称 = '奇异石'
        return { 名称 = 名称, 品质 = 品质, 类型 = 类型, 数值 = 基础数值, 等级 = 等级 }
    else
        local mc = math.random(1, #新宝石名称)
        local 名称 = 新宝石名称[mc][1]
        local 品质 = math.random(95, 110)
        local lx = math.random(2, #新宝石名称[mc])
        local 类型 = 新宝石名称[mc][lx]
        local 基础数值 = 新宝石属性[类型] or 0
        if not 新宝石属性[类型] then
            print('宝石属性 发生错误 ', 类型)
        end
        基础数值 = math.floor(基础数值 * 等级 * 品质 * 0.01)
        return { 名称 = 名称, 品质 = 品质, 类型 = 类型, 数值 = 基础数值, 等级 = 等级 }
    end
end

function 接口:指定新宝石(名称, 类型, 等级)
    if not 类型 then
        local mc
        for i, v in ipairs(新宝石名称) do
            if 名称 == v[1] then
                mc = i
                break
            end
        end
        local 品质 = math.random(95, 110)
        local lx = math.random(2, #新宝石名称[mc])
        local 类型 = 新宝石名称[mc][lx]
        local 基础数值 = 新宝石属性[类型] or 0
        if not 新宝石属性[类型] then
            print('宝石属性 发生错误 ', 类型)
        end
        基础数值 = math.floor(基础数值 * 等级 * 品质 * 0.01)
        return { 名称 = 名称, 品质 = 品质, 类型 = 类型, 数值 = 基础数值, 等级 = 等级 }
    else
        local 品质 = math.random(95, 110)
        local 基础数值 = 新宝石属性[类型] or 0
        if not 新宝石属性[类型] then
            print('宝石属性 发生错误 ', 类型)
        end
        基础数值 = math.floor(基础数值 * 等级 * 品质 * 0.01)
        return { 名称 = 名称, 品质 = 品质, 类型 = 类型, 数值 = 基础数值, 等级 = 等级 }
    end
end

function 接口:更新数值(item)
    local 等级 = item.等级
    local 品质 = item.品质
    local 类型 = item.宝石属性
    local 基础数值 = 新宝石属性[类型] or 0
    if not 新宝石属性[类型] then
        print('宝石属性 发生错误 ', 类型)
    end
    return math.floor(基础数值 * 等级 * 品质 * 0.01), math.random(95, 110)
end

function 接口:取所有召唤兽()
    return self:角色_召唤列表()
end

function 接口:取指定召唤兽(nid)
    return self:取指定召唤兽(nid)
end

function 接口:添加赞助(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    local user = __存档.查询账号(self.账号)
    if user then
        self.仙玉 = self.仙玉 + n
        self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y点积分')
        local 累计 = user.累充 + n

        __存档.修改累计(self.账号, 累计)
        return self.仙玉
    end
end

function 接口:更换称谓(s)
    for k, v in pairs(self.称谓列表) do
        if v == s then
            self:角色_更换称谓(k)
            return true
        end
    end

    return false
end

function 接口:剧情称谓是否存在(n)
    return self:剧情称谓是否存在(n)
end

function 接口:取当前地图等级()
    return self.当前地图.地图等级 or 0, self.当前地图.id
end

function 接口:进入PK(v, ...)
    self:进入PK(v, ...)
end

function 接口:进入观战(v)
    if not self.是否战斗 and not self.是否观战 then
        if ggetype(v) == '角色' then
            return self:进入观战(v)
        end
    end
end

function 接口:退出观战()
    self:退出观战()
end

function 接口:退出战斗()
    self:退出战斗()
end

local _添加当铺消耗 = {
    1000000,
    2000000,
    5000000,

}
function 接口:增加当铺()
    if self.其它.仓库数量 < 1 then
        self.其它.仓库数量 = 1
    end
    if self.其它.仓库数量 >= 4 then
        return "当铺数量已经达到上限！"
    end
    local 消耗 = _添加当铺消耗[self.其它.仓库数量]
    if self.银子 < 消耗 then
        return "你需要让我支付" .. 消耗 .. "两银子！"
    end
    self:角色_扣除银子(消耗)
    self.其它.仓库数量 = self.其它.仓库数量 + 1
    return "好的,你现在已经拥有" .. self.其它.仓库数量 .. "页当铺物品栏了！"
end

function 接口:进入战斗(v, ...)
    if not self.是否战斗 then
        local 脚本 = __脚本[v]
        if type(脚本) == 'table' and type(脚本.战斗初始化) == 'function' then
            return self:战斗_初始化(v, ...)
        else
            warn('战斗脚本错误')
        end
    end
end

function 接口:帮派捐款(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.帮派贡献 = self.帮派贡献 + n
    self:刷新属性()
    return self.帮派贡献
end

function 接口:更换守护抗性(k, r)
    local n = k == 1 and 2 or 1
    if self.守护抗性[n] and self.守护抗性[n] == r then
        return "主副抗性不能选中一样的呢！"
    end
    self.守护抗性[k] = r
    self:刷新属性()
    return "好的,我已经替你更换了守护抗性"
end

function 接口:扣除帮派成就(n)
    return self:角色_扣除成就(n)
end

function 接口:放入卡册(t)
    return self:放入卡册(t)
end

function 接口:重选修正(t)
    self:重选修正(t)
end

function 接口:补满修正()
    for i, t in ipairs(self.转生记录) do
        for k, v in pairs(t) do
            if k ~= "种族" then
                self.转生记录[i][k] = 1
            end
        end
    end
end

function 接口:取作坊数据(n)
    if self.作坊[n] then
        return self.作坊[n]
    end
end

-----------------------------------------------

function 接口:水陆报名()
    return self:水陆报名()
end

function 接口:进入水陆地图(list)
    if not __水陆大会:是否可进场() then
        return '非进场时间,无法进入'
    end
    local t = {}
    local 水陆队伍
    for i, v in ipairs(list) do
        local 是否报名 = __水陆大会:是否已报名(v.nid)
        水陆队伍 = 水陆队伍 or 是否报名.队伍
        if not 是否报名 or 水陆队伍 ~= 是否报名.队伍 then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        return table.concat(t, '、 ') .. '没有报名(或不是报名时队内成员),无法进入'
    end

    for i, v in ipairs(list) do
        __水陆大会:玩家进场(v.nid)
    end
    __水陆大会:进入地图(self)
end

function 接口:NPC移动(nid, x, y)
    self.rpc:NPC移动(nid, x, y)
    self.rpn:NPC移动(nid, x, y)
end

function 接口:置刷新属性(name, s)
    self.刷新的属性[name] = s
end

function 接口:招募机器人(...)
    return self:招募机器人(...)
end

function 接口:地图对象开关神行符(nid, flag)
    self.神行符 = flag
    self.rpc:地图对象开关神行符(nid, flag)
    self.rpn:地图对象开关神行符(nid, flag)
end

function 接口:取累积礼包列表()
    if __累计待领取数据[self.uid] then
        return __累计待领取数据[self.uid]
    end

    return {}
end

function 接口:领取累积礼包(i)
    __累计待领取数据[self.uid][i].领取id = self.id
    __累计待领取数据[self.uid][i].领取时间 = os.time()
    self.接口:添加物品({ __沙盒.生成物品 { 名称 = __累计待领取数据[self.uid][i].名称, 数量 = 1, 禁止交易 = true } })

    return '领取成功'
end

function 接口:取所有技能是否满熟练()
    for _, v in self:遍历技能() do
        if v.熟练度 < v.熟练度上限 then
            return false
        end
    end

    return true
end

function 接口:修改所有技能熟练度(数额)
    local 熟练 = math.floor(数额)

    for _, v in self:遍历技能() do
        v:修改熟练度(熟练)
    end

    return self.技能
end

-- 帮战
do
    function 接口:操控提示(nid)
        if __玩家[nid] then
            if __玩家[nid].帮派 == self.帮派 then
                return '龙神大炮正受我方操控'
            else
                return '龙神大炮正受敌方操控\nmenu\n掐灭它(进入战斗)\n我还有事'
            end
        end
    end

    function 接口:还原龙神大炮(nid, tnid)
        self:角色_还原龙神大炮(nid, tnid)
    end

    function 接口:操控龙神大炮(nid)
        self.操控大炮 = nid
        local 大本营 = __帮派[self.帮派].帮战信息.大本营
        if 大本营 == 1 then
            self:角色_上方开炮(nid)
        else
            self:角色_下方开炮(nid)
        end
        self.rpc:设置禁止移动(true)
    end

    function 接口:帮战间接战斗(nid)
        self:帮战进入战斗(nid)
    end

    function 接口:帮战进入挑战(nid)
        self:帮战进入挑战(nid)
    end

    function 接口:设置取消操作火塔(nid)
        if nid and __玩家[nid] then
            __玩家[nid].操作火塔 = nil
            __玩家[nid].rpc:设置禁止移动(false)
        end
    end

    function 接口:点亮火塔(nid, r)
        return self:点亮火塔(nid, r)
    end

    function 接口:设置操作火塔(nid)
        if nid and __玩家[nid] then
            __玩家[nid].操作火塔 = true
        end
    end

    function 接口:点亮冰塔(nid, r)
        return self:点亮冰塔(nid, r)
    end

    function 接口:设置取消操作冰塔(nid)
        if nid and __玩家[nid] then
            __玩家[nid].操作冰塔 = nil
            __玩家[nid].rpc:设置禁止移动(false)
        end
    end

    function 接口:设置操作冰塔(nid)
        if nid and __玩家[nid] then
            __玩家[nid].操作冰塔 = true
        end
    end

    function 接口:设置战场状态(flag)
        self.战场状态 = flag
    end

    function 接口:设置攻击塔(nid, tnid)
        if nid and __玩家[nid] then
            __玩家[nid].攻击塔 = tnid
            __玩家[nid].rpc:设置禁止移动(true)
        end
    end

    function 接口:设置取消攻击塔(nid)
        if nid and __玩家[nid] then
            __玩家[nid].攻击塔 = nil
            __玩家[nid].rpc:设置禁止移动(false)
        end
    end

    function 接口:设置取消攻击城门(nid)
        if nid and __玩家[nid] then
            __玩家[nid].攻击城门 = nil
            __玩家[nid].rpc:设置禁止移动(false)
        end
    end

    function 接口:设置攻击城门(nid, tnid)
        if nid and __玩家[nid] then
            __玩家[nid].攻击城门 = tnid
            __玩家[nid].rpc:设置禁止移动(true)
        end
    end

    function 接口:返回帮战总部()
        if self.帮派 then
            local map = __帮派[self.帮派].帮战信息.帮战地图
            if map then
                local 大本营 = __帮派[self.帮派].帮战信息.大本营
                local 大本营坐标 = {
                    { x = math.floor(9 * 20), y = math.floor((map.高度 - 8) * 20) },
                    { x = math.floor(105 * 20), y = math.floor((map.高度 - 91) * 20) },
                }
                self:移动_切换地图(map, 大本营坐标[大本营].x, 大本营坐标[大本营].y)
                self.战场状态 = nil
            end
        end
    end

    function 接口:参加帮派挑战()
        if self.帮派 and __帮派[self.帮派] and __帮派[self.帮派].帮战信息 then
            __帮战.高手挑战[self.帮派] = __帮战.高手挑战[self.帮派] or {}
            __帮战.高手挑战[self.帮派][#__帮战.高手挑战[self.帮派] + 1] = self.nid
        end
    end

    function 接口:创建龙神帮战()
        __帮战.匹配数据[1] = { '帮派1', '帮派2' }
        local 帮战地图 = __沙盒.生成地图(101392)
        帮战地图.是否帮战 = true
        --公共NPC
        帮战地图:添加NPC {
            名称 = "龙神大炮",
            外形 = 90002,
            脚本 = 'scripts/npc/长安/帮战/龙神大炮.lua',
            操控者 = '',
            X = 15,
            Y = 78
        }
        帮战地图:添加NPC { --下方营地外传送人
            名称 = "帮战传送人",
            外形 = 3038,
            脚本 = 'scripts/npc/长安/帮战/通用战场传送.lua',
            方向 = 0,
            X = 17,
            Y = 29
        }
        帮战地图:添加NPC { --上方营地外传送人
            名称 = "帮战传送人",
            外形 = 3038,
            脚本 = 'scripts/npc/长安/帮战/通用战场传送.lua',
            方向 = 2,
            X = 99,
            Y = 69
        }
        帮战地图:添加NPC { --挑战区传送人
            名称 = "帮战传送人",
            外形 = 3038,
            脚本 = 'scripts/npc/长安/帮战/通用战场传送.lua',
            方向 = 2,
            X = 109,
            Y = 14
        }


        --下方NPC
        帮战地图:添加NPC { --下方营地内传送人
            名称 = "帮战传送人",
            外形 = 3038,
            脚本 = 'scripts/npc/长安/帮战/下方大本营传送.lua',
            方向 = 1,
            X = 5,
            Y = 8,
            帮派 = __帮派[__帮战.匹配数据[1][1]]
        }
        帮战地图:添加NPC {
            名称 = "城门",
            外形 = 90004,
            脚本 = 'scripts/npc/长安/帮战/下方城门.lua',
            攻击者 = {},
            X = 17.5,
            Y = 16,
            帮派 = __帮派[__帮战.匹配数据[1][1]]
        }
        帮战地图:添加NPC {
            名称 = "烈火塔",
            外形 = 90003,
            脚本 = 'scripts/npc/长安/帮战/下方烈火塔1.lua',
            耐久 = 500,
            攻击者 = {},
            守护者 = {},
            X = 27.5,
            Y = 34.5,
            帮派 = __帮派[__帮战.匹配数据[1][1]]
        }
        帮战地图:添加NPC {
            名称 = "烈火塔",
            外形 = 90003,
            脚本 = 'scripts/npc/长安/帮战/下方烈火塔2.lua',
            耐久 = 500,
            攻击者 = {},
            守护者 = {},
            X = 44,
            Y = 24.5,
            帮派 = __帮派[__帮战.匹配数据[1][1]]
        }
        帮战地图:添加NPC {
            名称 = "玄冰塔",
            外形 = 90003,
            脚本 = 'scripts/npc/长安/帮战/下方玄冰塔1.lua',
            耐久 = 500,
            攻击者 = {},
            守护者 = {},
            X = 42,
            Y = 40,
            帮派 = __帮派[__帮战.匹配数据[1][1]]
        }
        帮战地图:添加NPC {
            名称 = "玄冰塔",
            外形 = 90003,
            脚本 = 'scripts/npc/长安/帮战/下方玄冰塔2.lua',
            耐久 = 500,
            攻击者 = {},
            守护者 = {},
            X = 56,
            Y = 31.5,
            帮派 = __帮派[__帮战.匹配数据[1][1]]
        }
        -- 帮战地图:添加NPC { --挑战区传送人
        --     名称 = "明鑫",
        --     称谓 = '挑战公证人'
        --     外形 = 3038,
        --     脚本 = 'scripts/npc/长安/帮战/挑战公证人.lua',
        --     方向 = 2,
        --     X = 119,
        --     Y = 8
        -- }

        --上方NPC
        帮战地图:添加NPC {
            名称 = "帮战传送人",
            外形 = 3038,
            脚本 = 'scripts/npc/长安/帮战/上方大本营传送.lua',
            方向 = 2,
            X = 110,
            Y = 77,
            帮派 = __帮派[__帮战.匹配数据[1][2]]
        }

        帮战地图:添加NPC {
            名称 = "城门",
            外形 = 90004,
            脚本 = 'scripts/npc/长安/帮战/上方城门.lua',
            攻击者 = {},
            X = 107.5,
            Y = 67,
            帮派 = __帮派[__帮战.匹配数据[1][2]]
        }


        帮战地图:添加NPC {
            名称 = "烈火塔",
            外形 = 90003,
            脚本 = 'scripts/npc/长安/帮战/上方烈火塔1.lua',
            耐久 = 500,
            攻击者 = {},
            守护者 = {},
            X = 85,
            Y = 63,
            帮派 = __帮派[__帮战.匹配数据[1][2]]
        }
        帮战地图:添加NPC {
            名称 = "烈火塔",
            外形 = 90003,
            脚本 = 'scripts/npc/长安/帮战/上方烈火塔2.lua',
            耐久 = 500,
            攻击者 = {},
            守护者 = {},
            X = 100,
            Y = 54.5,
            帮派 = __帮派[__帮战.匹配数据[1][2]]
        }
        帮战地图:添加NPC {
            名称 = "玄冰塔",
            外形 = 90003,
            脚本 = 'scripts/npc/长安/帮战/上方玄冰塔1.lua',
            耐久 = 500,
            攻击者 = {},
            守护者 = {},
            X = 73.5,
            Y = 56.5,
            帮派 = __帮派[__帮战.匹配数据[1][2]]
        }
        帮战地图:添加NPC {
            名称 = "玄冰塔",
            外形 = 90003,
            脚本 = 'scripts/npc/长安/帮战/上方玄冰塔2.lua',
            耐久 = 500,
            攻击者 = {},
            守护者 = {},
            X = 88,
            Y = 48,
            帮派 = __帮派[__帮战.匹配数据[1][2]]
        }


        for i = 1, #__帮战.匹配数据[1] do
            __帮派[__帮战.匹配数据[1][i]].帮战信息 = { 帮战状态 = true, 帮战地图 = 帮战地图, 大本营 = i, 显示信息 = { 名称 = __帮战.匹配数据[1][i], 耐久 = 3000, 帮派目前参战成员 = 0, 帮派成员胜利场次 = 0, 高手挑战胜利场次 = 0, 能量塔发动攻击数 = 0, 龙神大炮开炮次数 = 0, 本帮杀敌最高成员 = '', 本人杀敌 = 0, 胜场统计 = {}, 连胜记录 = {}, 个人杀敌 = {} } }
            if i == 1 then
                __帮派[__帮战.匹配数据[1][i]].帮战信息.敌对帮派 = __帮战.匹配数据[1][2]
            else
                __帮派[__帮战.匹配数据[1][i]].帮战信息.敌对帮派 = __帮战.匹配数据[1][1]
            end
        end

        return '创建成功'
    end

    function 接口:顶号进入帮战()
        if not self.帮派 then
            return
        end
        if not __帮派[self.帮派] then
            return
        end
        if not __帮派[self.帮派].帮战信息 then
            return
        end
        if __帮派[self.帮派].帮战信息 then
            if __帮派[self.帮派].帮战信息.帮战地图 then
                local map = __帮派[self.帮派].帮战信息.帮战地图
                local 大本营 = __帮派[self.帮派].帮战信息.大本营
                if map.id ~= self.当前地图.接口.id then
                    return
                end
                if map then
                    local 大本营坐标 = {
                        { x = math.floor(9 * 20), y = math.floor((map.高度 - 8) * 20) },
                        { x = math.floor(105 * 20), y = math.floor((map.高度 - 91) * 20) },
                    }
                    self:移动_切换地图(map, 大本营坐标[大本营].x, 大本营坐标[大本营].y)
                    self.帮战状态 = true
                    self.帮战前称谓 = self.称谓
                    self.称谓 = self.帮派 .. '成员'
                    self.rpc:切换称谓(self.nid, self.称谓)
                    self.rpn:切换称谓(self.nid, self.称谓)
                    local 对战信息 = {}
                    for k, v in pairs(__帮战.匹配数据) do
                        for q, w in pairs(v) do
                            if w == self.帮派 then
                                对战信息 = v
                            end
                        end
                    end
                    local 信息 = {
                        [1] = __帮派[对战信息[1]].帮战信息.显示信息,
                        [2] = __帮派[对战信息[2]].帮战信息.显示信息,
                    }
                    self.rpc:置对战信息(信息, self.帮派)
                end
            else
                self.帮战状态 = false
                return '帮战已结束或未开启'
            end
        end
    end

    function 接口:龙神帮战入场()
        if not self.帮派 then
            return '没有帮派不要在这里胡闹!'
        end
        if not __帮派[self.帮派] then
            return '未找到你的帮派,可能已解散请联系管理处理'
        end
        if not __帮派[self.帮派].帮战信息 then
            return '未找到你帮派的对战场景,请联系帮主确认'
        end
        if self.是否组队 then
            for _, v in self:遍历队友() do
                if not v.帮派 or v.帮派 ~= self.帮派 then
                    return '无法带非本帮人员进入帮战'
                end
            end
        end
        if __帮派[self.帮派].帮战信息 then
            if __帮派[self.帮派].帮战信息.帮战地图 then
                local map = __帮派[self.帮派].帮战信息.帮战地图
                local 大本营 = __帮派[self.帮派].帮战信息.大本营
                if map then
                    local 大本营坐标 = {
                        { x = math.floor(9 * 20), y = math.floor((map.高度 - 8) * 20) },
                        { x = math.floor(105 * 20), y = math.floor((map.高度 - 91) * 20) },
                    }
                    self:移动_切换地图(map, 大本营坐标[大本营].x, 大本营坐标[大本营].y)
                    self.帮战状态 = true
                    self.帮战前称谓 = self.称谓
                    self.称谓 = self.帮派 .. '成员'
                    self.rpc:切换称谓(self.nid, self.称谓)
                    self.rpn:切换称谓(self.nid, self.称谓)
                    local 对战信息 = {}
                    for k, v in pairs(__帮战.匹配数据) do
                        for q, w in pairs(v) do
                            if w == self.帮派 then
                                对战信息 = v
                            end
                        end
                    end
                    local 信息 = {
                        [1] = __帮派[对战信息[1]].帮战信息.显示信息,
                        [2] = __帮派[对战信息[2]].帮战信息.显示信息,
                    }
                    self.rpc:置对战信息(信息, self.帮派)
                end
            else
                self.帮战状态 = false
                return '帮战已结束或未开启'
            end
        end
    end

    function 接口:龙神帮战退场()
        -- self.复活标记 = nil
        if self.是否战斗 then
            self.战斗.战场:强制退出战斗()
        end
        self.攻击城门 = nil
        self.操控大炮 = nil
        self.操作火塔 = nil
        self.操作冰塔 = nil
        self.攻击塔 = nil
        self.帮战状态 = nil
        self.rpc:隐藏帮战信息()
        self.称谓 = self.帮战前称谓
        self.rpc:切换称谓(self.nid, self.称谓)
        self.rpn:切换称谓(self.nid, self.称谓)
        if __副本地图[self.当前地图.接口.id] and self.当前地图.接口.名称 == '龙神比武场' then
            self.接口:切换地图(1001, 345, 46)
        end
    end

    function 接口:取对战信息()
        local 对战信息 = {}
        for k, v in pairs(__帮战.匹配数据) do
            for q, w in pairs(v) do
                if w == self.帮派 then
                    对战信息 = v
                end
            end
        end
        local 信息 = {
            [1] = __帮派[对战信息[1]].帮战信息.显示信息,
            [2] = __帮派[对战信息[2]].帮战信息.显示信息,
        }
        return 信息
    end
end

function 接口:打开雕版窗口(...)
    return self.rpc:打开雕版窗口(...)
end

function 接口:刷新雕版数据(...)
    return self.rpc:刷新雕版数据(...)
end

--===============================================================================
if not package.loaded.角色接口_private then
    package.loaded.角色接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('角色接口_private')

local 角色接口 = class('角色接口')

function 角色接口:初始化(P)
    _pri[self] = P
    self.是否玩家 = true
end

function 角色接口:__index(k)
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

function 角色接口:__pairs(k)
    return 接口
end

return 角色接口
