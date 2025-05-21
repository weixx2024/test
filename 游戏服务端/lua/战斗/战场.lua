local function _get(s, name)
    if not s then
        return
    end
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local function _速度排序(a, b)
    return a.速度 > b.速度
end

local 战场 = class('战场')

function 战场:初始化(脚本, arg)
    self._数据 = {}
    self._对象表 = {}
    self._观战表 = {}

    self._等待表 = {} -- 战斗操作等待
    self._玩家表 = {} -- 战斗中的玩家

    self.阶段 = 1
    self.回合数 = 1
    self.等待时长 = 0

    if ggetype(脚本) == 'string' then
        self.脚本 = 脚本
        local func = _get(self.脚本, '战斗初始化')
        if type(func) == 'function' then
            ggexpcall(func, self, table.unpack(arg))
        end
        self.战斗类型 = 1
        self.是否惩罚 = _get(self.脚本, '是否惩罚')
        self.回合数上限 = 150
    elseif ggetype(脚本) == '角色' then
        self.战斗类型 = type(arg) == "number" and arg or 1
        --1脚本 2切磋 3帮战 4水陆 5强杀 6 皇宫挑战赛
        self.是否PK = true
        self.回合数上限 = 60
    end
end

function 战场:更新(sec)
    if self.等待时长 then
        if self.等待时长 > 0 then
            self.等待时长 = self.等待时长 - 1
        end
        self:机器人()
        if self.阶段 == 1 then
            self:更新阶段超时()
        elseif self.阶段 == 2 then
            self:更新阶段超时()
        elseif self.阶段 == 3 then
            self:更新阶段自动()
        elseif self.阶段 == 4 then
            self:更新阶段超时()
        elseif self.阶段 == 5 then
            self:更新阶段超时()
        elseif self.阶段 == 6 then
            self:更新阶段超时()
        elseif self.阶段 == 7 then
            self:更新阶段结束()
        end
    end
end

-- 机器人无需等待
function 战场:机器人()
    for k, v in pairs(self._等待表) do --超时
        if v.是否机器人 then
            self._等待表[k] = nil
        end
    end
    if not next(self._等待表) then
        self:_CALL()
    end
end

function 战场:更新阶段超时(...)
    if self.等待时长 <= 0 then
        self:_超时()
    end
end

function 战场:更新阶段自动(...)
    if self.等待时长 <= 0 then
        for k, v in pairs(self._等待表) do
            v:执行自动(true)
        end
        self:_超时()
        return
    end
    if self.等待时长 <= 57 then
        for k, v in pairs(self._等待表) do
            if v:执行自动() then
                self._等待表[k] = nil
            end
        end
    end
    if not next(self._等待表) then
        self:_CALL()
    end
end

function 战场:更新阶段结束()
    if self._定时 then
        self._定时:删除()
    end
    self:战斗结束()
    self:脚本战斗结束(self.是否结束 == 1) --1敌方全死
    coroutine.xpcall(self.来源, self.是否结束 == 1) --1敌方全死
    self:战斗结束触发领悟()
end

function 战场:_CALL()
    if coroutine.xpcall(self.co) == coroutine.FALSE then
        __世界:ERROR('战斗脚本出现错误')
        for k, v in pairs(self._玩家表) do
            v.rpc:提示窗口('#R战斗过程出错，请联系管理员解决！')
        end
        if self._定时 then
            self._定时:删除()
        end
        self:战斗结束()
        coroutine.xpcall(self.来源)
    end
end

function 战场:_超时()
    for k, v in pairs(self._等待表) do --超时
        self._等待表[k] = nil
    end
    self:_CALL()
end

function 战场:强制退出战斗()
    if self._定时 then
        self._定时:删除()
    end
    self:战斗结束()
    coroutine.xpcall(self.来源)
end

function 战场:脚本战斗回合开始(...)
    local func = _get(self.脚本, '战斗回合开始')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:脚本战斗回合结束(...)
    local func = _get(self.脚本, '战斗回合结束')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:脚本战斗开始(...)
    local func = _get(self.脚本, '战斗开始')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:进场喊话(...)
    local func = _get(self.脚本, '进场喊话')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:脚本战斗结束(...)
    local func = _get(self.脚本, '战斗结束')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:加入敌方(i, 对象, ...)
    return self:加入(i + 100, 对象, ...)
end

function 战场:加入我方(i, 对象, ...)
    return self:加入(i, 对象, ...)
end

function 战场:加入观战(玩家)
    table.insert(self._观战表, 玩家)
end

function 战场:退出观战(玩家)
    for i, v in ipairs(self._观战表) do
        if v.名称 == 玩家.名称 then
            table.remove(self._观战表, i)
        end
    end
end

function 战场:加入(i, 对象, ...)
    对象 = require('战斗/对象/对象')(i, 对象, self, ...)
    self._对象表[i] = 对象
    return 对象
end

function 战场:遍历敌方()
    return function(list, i)
        for n = i + 1, 200 do
            if list[n] and not list[n].是否孩子 then
                return n, list[n]
            end
        end
    end, self._对象表, 100
end

function 战场:遍历我方()
    return function(list, i)
        for n = i + 1, 100 do
            if list[n] and not list[n].是否孩子 then
                return n, list[n]
            end
        end
    end, self._对象表, 0
end

function 战场:遍历敌方玩家()
    return function(list, i)
        for n = i + 1, 200 do
            if list[n] and list[n].是否玩家 then
                return n, list[n]
            end
        end
    end, self._对象表, 100
end

function 战场:遍历我方玩家()
    return function(list, i)
        for n = i + 1, 100 do
            if list[n] and list[n].是否玩家 then
                return n, list[n]
            end
        end
    end, self._对象表, 0
end

function 战场:遍历玩家()
    return function(list, i)
        for n = i + 1, 200 do
            if list[n] and list[n].是否玩家 then
                return n, list[n]
            end
        end
    end, self._对象表, 0
end

function 战场:退出(i)
    local 对象 = self._对象表[i]
    if 对象 then
        if not 对象.是否玩家 then
            对象:战斗结束()
        end
        self._对象表[i] = nil
    end
    return 对象
end

function 战场:取对象(i)
    return self._对象表[i]
end

function 战场:取观战列表()
    return self._观战表
end

function 战场:是否在场(对象)
    for k, v in self:遍历对象() do
        if v.nid == 对象.nid then
            return true
        end
    end
    return false
end

function 战场:遍历对象()
    return next, self._对象表
end

function 战场:遍历观战()
    return next, self._观战表
end

function 战场:指令开始()
    local t = {}
    for k, v in self:遍历对象() do
        t[k] = require('战斗/回合数据')()
        v:置接收数据(t[k])
    end
    return t
end

function 战场:指令结束()
    for k, v in self:遍历对象() do
        v:置接收数据(nil)
    end
end

function 战场:取敌方存活数()
    local n = 0
    for k, v in self:遍历敌方() do
        if not v.是否死亡 and not v.是否孩子 then
            n = n + 1
        end
    end
    return n
end

function 战场:取我方存活数()
    local n = 0
    for k, v in self:遍历我方() do
        if not v.是否死亡 and not v.是否孩子 then
            n = n + 1
        end
    end
    return n
end

function 战场:取数据(位置)
    local t = {}
    for k, v in self:遍历对象() do
        t[k] = v:取数据(位置)
    end
    return t
end

function 战场:战斗重连(k)
    local v = self._等待表[k]
    if v then
        if self.阶段 == 3 then
            v:打开菜单(self.等待时长)
        else
            self._等待表[k] = nil
            if not next(self._等待表) then
                self:_CALL()
            end
        end
    end
end

function 战场:战斗数据返回(k, src)
    local v = self._等待表[k]
    if v then
        self._等待表[k] = nil
        if src == '战斗数据' then
            if v.是否逃跑 then
                v:战斗结束()
                v.rpc:退出战斗()
            end
        end

        if self.阶段 ~= 3 then
            -- 非操作 返回时， 把等代表中所有助战删除（防止播放战斗时切换无返回）
            for _k, _v in pairs(self._等待表) do
                if _v.是否助战 or _v.是否断线 then
                    self._等待表[_k] = nil
                end
            end
        end
        if not next(self._等待表) then
            self:_CALL()
        end
    end
end

function 战场:战斗操作返回(k, 人物, 召唤)
    local v = self._等待表[k]
    if v and self.阶段 == 3 then
        if v:菜单返回(人物, 召唤) then
            if v._定时 then
                v._定时:删除()
            end
            self._等待表[k] = nil
            if not next(self._等待表) then
                self:_CALL()
            end
        end
    end
end

function 战场:播放动作返回(动作id)
    for i, v in pairs(self._数据) do
        if next(v) ~= nil then
            for _i, _v in pairs(v) do
                if type(_v) == "table" then
                    if _v and _v.nid == 动作id then
                        self._数据[i][_i] = nil
                        return
                    end
                end
            end
        end
    end
end

function 战场:战斗开始()
    self:脚本战斗开始()
    for k, v in pairs(self._对象表) do
        v:战斗开始()
    end
    self.来源 = coroutine.running()
    coroutine.xpcall(
        function()
            self:_战斗循环()
        end
    )
    return coroutine.yield()
end

function 战场:战斗结束()
    -- 观战结束战斗
    for k, v in pairs(self._观战表) do
        v:退出观战()
    end
    -- 玩家结束战斗
    for k, v in pairs(self._对象表) do
        v:战斗结束()
        if v.是否玩家 then
            v.rpc:退出战斗()
        end
    end
end

function 战场:战斗结束触发领悟()
    -- 玩家结束战斗
    for k, v in pairs(self._对象表) do
        if v.是否召唤 then
            v:战斗结束触发领悟()
        end
    end
end

--======================================================================
function 战场:_阶段_进入战斗()
    self.阶段 = 1
    self:指令开始()
    for k, v in self:遍历对象() do
        v:进入战斗()
    end
    for k, v in self:遍历对象() do
        if v._定时 then
            v._定时:删除()
        end
        v.ev:战斗开始(v, v.当前数据)
    end
    self:指令结束()
    local data = self:取数据(101)
    for k, v in self:遍历敌方() do
        if v.是否玩家 and (not v.是否助战 or v.是否队长) then
            self._等待表[k] = v
            v.rpc:进入战斗(data, v.位置, self.回合数)
        end
    end
    local data = self:取数据(1)
    for k, v in self:遍历我方() do
        if v.是否玩家 and (not v.是否助战 or v.是否队长) then
            self._等待表[k] = v
            v.rpc:进入战斗(data, v.位置, self.回合数)
        end
    end



    self.等待时长 = 3
    coroutine.yield()
end

function 战场:_阶段_孩子喊话(回合数)
    self.阶段 = 2

    self._数据 = self:指令开始()
    local 孩子表 = {}

    for k, v in pairs(self._对象表) do
        if v.是否玩家 then
            self._玩家表[k] = v
        end

        if v.是否孩子 then
            table.insert(孩子表, v)
        end
    end

    table.sort(孩子表, _速度排序)

    while next(孩子表) do
        local v = table.remove(孩子表, 1)
        local 演算数据 = v:孩子喊话()
        if 演算数据 then
            self._数据[v.位置] = 演算数据
        end
    end

    self:指令结束()

    local 时长 = 0
    for k, v in pairs(self._数据) do
        时长 = 时长 + v.时长
    end

    for k, v in pairs(self._玩家表) do
        if not v.是否助战 or v.是否队长 then
            self._等待表[k] = v
            v.rpc:孩子喊话(self._数据)
        end
    end

    --发送数据到观战列表
    for k, v in pairs(self._观战表) do
        v.rpc:孩子喊话(self._数据)
    end
    self.等待时长 = 3 + 时长
    coroutine.yield()
end

function 战场:_阶段_打开菜单(回合数)
    self.阶段 = 3
    self.等待时长 = 60
    for k, v in pairs(self._对象表) do
        v.完成指令 = false
    end
    for k, v in pairs(self._对象表) do
        if v.是否玩家 then
            coroutine.xpcall(
                function()
                    if not v.是否助战 or v.是否队长 then
                        self._等待表[k] = v
                        v:打开战斗菜单(60)
                    end
                end
            )
        end
    end

    coroutine.yield()
end

function 战场:_阶段_回合开始(回合数)
    self.阶段 = 4
    self._数据 = self:指令开始()
    for k, v in pairs(self._对象表) do
        v:回合开始()
    end
    self:指令结束()

    for k, v in pairs(self._玩家表) do
        if not v.是否助战 or v.是否队长 then
            self._等待表[k] = v
            v.rpc:回合开始(self._数据)
        end
    end

    --发送数据到观战列表
    for k, v in pairs(self._观战表) do
        v.rpc:回合开始(self._数据)
    end
    self.等待时长 = 3
    coroutine.yield()
end

function 战场:_阶段_回合演算(回合数)
    self.阶段 = 5
    local 先手表 = {}
    for k, v in pairs(self._对象表) do
        table.insert(先手表, v)
    end
    table.sort(先手表, _速度排序)

    -- 这里的数据不用回合开始, 是因为出手要按照速度顺序
    self._数据 = {}
    local 后手表 = {}
    local 已出手 = {}
    while next(先手表) do
        local v = table.remove(先手表, 1)
        if self:是否在场(v) then
            local 演算数据, 是否行动 = v:回合演算()
            if 是否行动 then
                已出手[v.nid] = true
                table.insert(self._数据, 演算数据)
            else
                后手表[v.nid] = v
            end
            if self.重新排序 then
                table.sort(先手表, _速度排序)
                self.重新排序 = nil
            end
            if self.新增对象 then --  试试吧，这样写没问题，主要是看看别引起其他的 你整2个号就行
                for i = #self.新增对象, 1, -1 do
                    table.insert(先手表, 1, self.新增对象[i])
                end
                self.新增对象 = nil
            end
            for _, k in pairs(后手表) do
                if k.重新行动 then
                    k.重新行动 = nil
                    if not 已出手[k.nid] then
                        后手表[k.nid] = nil
                        table.insert(先手表, k)
                        table.sort(先手表, _速度排序)
                    end
                end
            end
        end
        -- 敌方全死
        if self:取敌方存活数() == 0 then
            self.是否结束 = 1
            break
        end
        -- 我方全死
        if self:取我方存活数() == 0 then
            self.是否结束 = 2
            break
        end
    end

    local 时长 = 0
    for k, v in pairs(self._数据) do
        时长 = 时长 + v.时长
    end

    --逃跑会删除对象表，所以用玩家表
    for k, v in pairs(self._玩家表) do
        self._等待表[k] = v
        v.rpc:战斗数据(self._数据)
    end

    --发送数据到观战列表
    for k, v in pairs(self._观战表) do
        v.rpc:战斗数据(self._数据)
    end

    self.等待时长 = 60 + 时长
    coroutine.yield()
end

function 战场:_阶段_回合结束(回合数)
    self.阶段 = 6

    self._数据 = self:指令开始()
    for k, v in pairs(self._对象表) do
        v:回合结束()
    end
    self:指令结束()

    for k, v in pairs(self._玩家表) do --BUFF被动
        if not v.是否助战 or v.是否队长 then
            self._等待表[k] = v
            v.rpc:回合结束(self._数据)
        end
    end

    --发送数据到观战列表
    for k, v in pairs(self._观战表) do
        v.rpc:回合结束(self._数据)
    end

    self.等待时长 = 3
    coroutine.yield()
end

function 战场:_战斗循环()
    self.co = coroutine.running()
    self._定时 = __世界:定时(
        1000,
        function(ms)
            self:更新()
            return ms
        end
    )
    self:_阶段_进入战斗() --1
    --========================================================================
    repeat
        self._玩家表 = {}
        local 回合数 = self.回合数
        self:_阶段_孩子喊话(回合数) --2
        self:_阶段_打开菜单(回合数) --3
        self:_阶段_回合开始(回合数) --4
        self:_阶段_回合演算(回合数)
        self:_阶段_回合结束(回合数) --6
        self.回合数 = self.回合数 + 1
        if self.回合数 >= self.回合数上限 then
            self.是否结束 = 0
        end
    until self.是否结束
    self.阶段 = 7
    return self.是否结束
end

function 战场:取助战对象(位置)
    local 助战表 = {}
    if 位置 > 100 then
        for k, v in self:遍历敌方玩家() do
            if v.是否玩家 and v.是否助战 then
                助战表[k] = v
            end
        end
    else
        for k, v in self:遍历我方玩家() do
            if v.是否玩家 and v.是否助战 then
                助战表[k] = v
            end
        end
    end
    return 助战表
end

return 战场

-- 嘿  这里加的事情
