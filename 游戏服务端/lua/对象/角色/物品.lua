local 角色 = require('角色')


function 角色:物品_初始化()
    local 存档物品 = self.物品
    do
        local _物品表 = {} --实际存放
        self.刷新的物品 = {} --变更的

        self.物品 = --虚假的，用作监视删除，刷新
            setmetatable(
                {},
                {
                    __newindex = function(t, i, v)
                        if v then
                            v.rid = self.id
                            v.位置 = i
                            self.刷新的物品[i] = v
                            v:更新来源(self.物品, i)
                        else
                            local k = _物品表[i].nid
                            __垃圾[k] = _物品表[i]
                            __垃圾[k].rid = -1
                            self.刷新的物品[i] = false
                        end
                        _物品表[i] = v
                    end,
                    __index = _物品表,
                    __pairs = function(...)
                        return next, _物品表
                    end
                }
            )
    end

    do
        local _装备表 = {} --实际存放
        self.装备 =
            setmetatable(
                {},
                {
                    __newindex = function(t, i, v)
                        if v then
                            v.rid = self.id
                            v.位置 = i | 256
                            v:更新来源(self.装备, i)
                        end
                        _装备表[i] = v
                    end,
                    __index = _装备表,
                    __pairs = function(...)
                        return next, _装备表
                    end
                }
            )
    end

    do
        local _仓库表 = {} --实际存放
        self.仓库 =
            setmetatable(
                {},
                {
                    __newindex = function(t, i, v)
                        if v then
                            v.rid = self.id
                            v.位置 = i | 512
                            v:更新来源(self.仓库, i)
                        else
                            local k = _仓库表[i].nid
                            __垃圾[k] = _仓库表[i]
                            __垃圾[k].rid = -1
                        end
                        _仓库表[i] = v
                    end,
                    __index = _仓库表,
                    __pairs = function(...)
                        return next, _仓库表
                    end
                }
            )
    end

    if type(存档物品) == 'table' then
        for _, v in pairs(存档物品) do
            if not __物品[v.nid] or __物品[v.nid].rid == v.rid then
                local k = v.位置
                if k & 256 == 256 then
                    self.装备[k & 255] = require('对象/物品/物品')(v)
                elseif k & 512 == 512 then
                    self.仓库[k & 255] = require('对象/物品/物品')(v)
                else
                    self.物品[k] = require('对象/物品/物品')(v)
                end
            end
        end
    end
    do -- task
        local kname
        local function task(_, ...)
            for i, v in pairs(self.物品) do
                local fun = v[kname]
                if type(fun) == 'function' then
                    local r = { coroutine.xpcall(fun, v.接口, ...) }
                    if r[1] ~= coroutine.FALSE and r[1] ~= nil then
                        return table.unpack(r)
                    end
                end
            end
        end

        self.item =
            setmetatable(
                {},
                {
                    __index = function(_, k)
                        kname = k
                        return task
                    end
                }
            )
    end
    self:刷新装备属性()
end

function 角色:物品_更新()
    if next(self.刷新的物品) then
        coroutine.xpcall(
            function()
                if self.rpc:请求刷新物品() then
                    local t = {}
                    for k, v in pairs(self.刷新的物品) do
                        t[k] = v and v:取简要数据()
                    end
                    self.rpc:刷新物品(t)
                end
                self.刷新的物品 = {}
            end
        )
    end
end

function 角色:物品_获取(名称)
    for k, v in self:物品_遍历物品() do
        if v.名称 == 名称 then
            return v
        end
    end
end

function 角色:指定物品_获取(名称,sl)
    for k, v in self:物品_遍历物品() do
        if v.名称 == 名称 then
            if sl and v.数量 and v.数量 >= sl then
                return v
            elseif sl == nil then
                return v
            end
        end
    end
end

function 角色:物品_获取地图飞行旗(id)
    local list = {}
    for k, v in self:物品_遍历物品() do
        if v.单坐标飞行旗 then
            if v.坐标.id ~= nil and v.坐标.id == id then
                table.insert(list, { i = k, nid = v.nid, 名称 = v.名称, id = v.坐标.id, X = v.坐标.X, Y = v.坐标.Y, 单坐标飞行旗 = true })
            end
        end

        if v.多坐标飞行旗 then
            if #v.坐标 ~= 0 then
                for _k, _v in pairs(v.坐标) do
                    if _v.id ~= nil and _v.id == id then
                        table.insert(list,
                            { i = k, nid = _v.nid, 名称 = _v.名称, id = _v.id, X = _v.X, Y = _v.Y, 多坐标飞行旗 = true })
                    end
                end
            end
        end
    end
    return list
end

function 角色:角色_小地图使用飞行旗(v)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        local item = self.物品[v.i]

        if item then
            local r = item:小地图使用飞行旗(self.接口, v)
        end
    end
end

function 角色:角色_包裹数量() --页数
    -- if gge.isdebug then
    --     return 4
    -- end
    return self.转生 + 1
end

function 角色:物品_遍历物品(p)
    local a, b
    if type(p) == 'number' then
        a = (p - 1) * 24
        b = a + 24
    else
        a, b = 0, self:角色_包裹数量() * 24
    end
    return function()
        a = a + 1
        while a <= b do
            if self.物品[a] then
                return a, self.物品[a]
            end
            a = a + 1
        end
    end
end

function 角色:物品_遍历空位(p)
    local a, b
    if type(p) == 'number' then
        a = (p - 1) * 24
        b = a + 24
    else
        a, b = 0, self:角色_包裹数量() * 24
    end
    return function()
        a = a + 1
        while a <= b do
            if not self.物品[a] then
                return a
            end
            a = a + 1
        end
    end
end

function 角色:物品_遍历所有(p)
    local a, b
    if type(p) == 'number' then
        a = (p - 1) * 24
        b = a + 24
    else
        a, b = 0, self:角色_包裹数量() * 24
    end
    return function()
        a = a + 1
        if a <= b then
            return a, self.物品[a]
        end
    end
end

function 角色:物品_查找空位(p)
    return self:物品_遍历空位(p)()
end

function 角色:物品_查找位置(item, p)
    for i, v in self:物品_遍历物品(p) do
        if v:检查合并(item) then
            return i, v
        end
    end
    return self:物品_遍历空位(p)()
end

function 角色:物品_查找位置2(item, p)
    for i, v in self:物品_遍历物品(p) do
        if v:检查合并2(item) then
            return i, v
        end
    end
    return self:物品_遍历空位(p)()
end

function 角色:物品_交换合并(a, b) --拿起的是a
    local A, B = self.物品[a], self.物品[b]
    if A and B and B:检查合并2(A) then
        if not B:合并(A) then
            B:合并2(A)
            return A, B
        end
        return B
    else
        self.物品[a] = B
        self.物品[b] = A
        return true
    end
end

function 角色:物品_检查空间(t, ...)
end

local function _协程遍历空位(self, p)
    return coroutine.wrap(
        function()
            for i in self:物品_遍历空位(p) do
                coroutine.yield(i)
            end
        end
    )
end

function 角色:物品_检查添加(list)
    if type(list) ~= 'table' then
        return
    end
    if #list == 0 then
        return {}
    end
    for i, v in ipairs(list) do
        if ggetype(v) == '物品接口' then
            v = v[0x4253]
            list[i] = v
        end
        if ggetype(v) ~= '物品' then
            return false
        end
    end

    local 位置 = {}
    local 取空 = _协程遍历空位(self)
    for a, item in ipairs(list) do
        if item.是否叠加 then
            for _, v in self:物品_遍历物品() do
                if v:检查合并(item) then
                    位置[a] = v
                    goto continue
                end
            end
        end

        local i = 取空()
        if i then
            位置[a] = i
            goto continue
        end

        do return false end

        ::continue::
    end

    return 位置
end

function 角色:物品_添加(list)
    -- for i, v in ipairs(list) do
    --     if ggetype(v) == '物品接口' then
    --         v = v[0x4253]
    --         list[i] = v
    --     end
    --     if ggetype(v) ~= '物品' then
    --         return false
    --     end
    -- end
    -- local 叠加后 = {}
    -- local 处理后 = {}
    -- for i, v in ipairs(list) do
    --     if 叠加后[v.名称] then
    --         if 叠加后[v.名称]:检查合并(v) then
    --             叠加后[v.名称]:合并(v)
    --         else
    --             table.insert(处理后, v)
    --         end
    --     else
    --         叠加后[v.名称] = v
    --     end
    -- end
    -- for k,v in pairs(叠加后) do
    --     table.insert(处理后, v)
    -- end
    -- list = 处理后


    local 位置 = self:物品_检查添加(list)


    if type(位置) == 'table' then
        for i, v in ipairs(位置) do
            if type(v) == 'number' then
                self.物品[v] = list[i]
            else
                v:合并(list[i])
            end
        end
        return true
    end
end

--====================================================================================
function 角色:角色_打开物品窗口(nid)
    local wx
    if nid and self.是否组队 then
        for i,p in self:遍历队伍() do
            if p.nid == nid then
                p.窗口.物品 = true
                local wx = p.原形
                if p.武器 and p.武器 ~= 0 then
                    wx = p.武器
                end
                return p.银子, p.存银, p.师贡, p:角色_包裹数量(), wx 
            end
        end
    else
        self.窗口.物品 = true
        wx = self.原形
        if self.武器 and self.武器 ~= 0 then
            wx = self.武器
        end
    end
    return self.银子, self.存银, self.师贡, self:角色_包裹数量(), wx
end


function 角色:角色_关闭物品窗口()
    self.窗口.物品 = false
end

function 角色:角色_物品列表(p, sum,nid)
    if nid and self.是否组队 then
        for i,x in self:遍历队伍() do
            if x.nid == nid then
                if  type(p) == 'number' then
                    local r = {}
                    for i, v in x:物品_遍历物品(p) do
                        i = i % 24
                        if i == 0 then
                            i = 24
                        end
                        r[i] = v:取简要数据(x, sum)
                    end
                    return r
                end
            end
        end
    end
    if type(p) == 'number' then
        local r = {}
        for i, v in self:物品_遍历物品(p) do
            i = i % 24
            if i == 0 then
                i = 24
            end
            r[i] = v:取简要数据(self, sum)
        end
        return r
    end
    return {}
end

function 角色:角色_物品列表1(p, sum)
    if type(p) == 'number' then
        local r = {}
        for i, v in self:物品_遍历物品(p) do
            if v.是否装备 then
                r[#r+1] = v:取简要数据(self, sum)
                r[#r].性别 = v.性别
            end
        end
        return r
    end
    return {}
end

function 角色:角色_装备列表(nid)
    if nid and self.是否组队 then
        for i,p in self:遍历队伍() do
            if p.nid == nid then
                local r = {}
                for i, v in pairs(p.装备) do
                    r[i] = v:取简要数据()
                end
                return r
            end
        end
    end
    local r = {}
    for i, v in pairs(self.装备) do
        r[i] = v:取简要数据()
    end
    return r
end

function 角色:角色_物品使用(i)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        local item = self.物品[i]

        if item then
            if item.是否装备 then
                local r = item:检查要求(self)
                if r == true then
                    local n = item.部位
                    if self.装备[n] then
                        self.装备[n]:脱下(self)
                    end
                    item:穿上(self)
                    self.物品[i] = self.装备[n]
                    self.装备[n] = item
                  
                    self:检查装备()
                    self:刷新属性()
                    return 3, n
                end
                return r
            elseif item.人物是否可用 then
                local r = item:使用(self.接口)
                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据()
            elseif item.是否变身卡 then
                local r = item:使用变身卡(self.接口)
                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据()
            elseif item.是否符文 then
                local r = item:使用符文(self.接口)
                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据()
            end
        end
    end
end

function 角色:角色_召唤物品使用(i, 召唤)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        local item = self.物品[i]
        if item then
            if item.是否装备 then
            elseif item.召唤是否可用 then
                local r = item:使用(召唤.接口)

                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据(self.接口, 召唤.接口)
            end
        end
    end
end
function 角色:角色_物品列表管理(p, nid, sum)
    local 找到 = false
    local 玩家
    if nid then
        for k, j in __世界:遍历玩家() do
            if j.nid == nid then
                找到 = true
                玩家 = j
                break
            end
        end
        if 找到 then
            if type(p) == 'number' then
                local r = {}
                for i, v in 玩家:物品_遍历物品(p, nid) do
                    i = i % 24
                    if i == 0 then
                        i = 24
                    end
                    r[i] = v:取简要数据(self, sum)
                end
                return r
            end
        else
            return 1
        end
    end

    return 1
end
function 角色:角色_物品丢弃(i, n)
    if self.是否战斗 and self.是否摆摊 and self.是否交易 then
        return
    end
    if self.不可丢弃 then
        self.rpc:常规提示("#Y该道具无法丢弃！")
        return
    end
    if self.交易锁 then
        self.rpc:常规提示("#Y点开背包解锁，注册用的安全码解锁！")
        return
    end
    if type(i) ~= 'number' then
        return
    end
    if self.物品[i] then
        return self.物品[i]:丢弃(n)
    end
end

function 角色:角色_物品交换(a, b)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        if type(a) == 'number' and type(b) == 'number' and self.物品[a] then
            -- if self.物品[b] and self.物品[b].nid == self.物品[a].nid then
            --     return
            -- end


            if b & 0xFF00 ~= 0 then
                b = self:物品_查找空位(b >> 8)
            end
            if b then
                local A, B = self:物品_交换合并(a, b)
                if A == true then
                    return 2 --交换
                elseif B then
                    return 3, A:取简要数据(), B:取简要数据()
                elseif A then
                    return 1, A:取简要数据() --合并
                end
            end
        end
    end
end

function 角色:角色_物品拆分(a, b, n)
    if self.是否战斗 and self.是否摆摊 and self.是否交易 then
        return
    end
    if type(a) ~= 'number' or type(b) ~= 'number' or type(n) ~= 'number' then
        return
    end
    if not self.物品[a] or self.物品[a].数量 < n or n < 1 or self.物品[b] then
        return
    end
    if self.物品[a].数量 == n then
        self:物品_交换合并(a, b)
        return 2
    end
    self.物品[b] = self.物品[a]:拆分(n)
    return 1, self.物品[a]:取简要数据(), self.物品[b]:取简要数据()
end

function 角色:角色_脱下装备(i)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        if type(i) == 'number' and self.装备[i] then
            local n = self:物品_查找空位()
            if n then
                self.物品[n] = self.装备[i]
                if self.装备[i].是否有效 ~= false then
                    self.装备[i]:脱下(self)
                end

                self.装备[i] = nil
                self:检查装备()
                self:刷新属性()
                return true
            end
        end
    end
end

function 角色:角色_物品整理(p)
    if self.是否战斗 or self.是否摆摊 or self.是否交易 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品(p) do
        self.物品[i] = nil
        table.insert(list, v)
    end
    table.sort(list, function(a, b)
        return (a.id or 0) < (b.id or 0)
    end)
    local ii = (p - 1) * 24
    for i, v in ipairs(list) do
        self.物品[i + ii] = v
    end
end
