local 多目标技能 = require('数据库/孩子信息库').多目标技能

local 战斗对象 = require('战斗对象')

function 战斗对象:事件_初始化()
    do
        local kname
        local function event(_, ...)
            local knames = kname
            for i, v in pairs(self.BUFF列表) do
                local fun = v[knames]
                if type(fun) == 'function' then
                    local r = { coroutine.xpcall(fun, v, ...) }
                    if r[1] ~= coroutine.FALSE and r[1] ~= nil then
                        return table.unpack(r)
                    end
                end
            end
            for i, v in pairs(self.法术列表) do
                --if v.是否被动 then
                local fun = v[knames]
                if type(fun) == 'function' then
                    local r = { coroutine.xpcall(fun, v, ...) }
                    if r[1] ~= coroutine.FALSE and r[1] ~= nil then
                        return table.unpack(r)
                    end
                end
                --end
            end
        end

        self.ev =
            setmetatable(
                {},
                {
                    __index = function(_, k)
                        kname = k
                        return event
                    end
                }
            )
    end
end

function 战斗对象:生成镜像()
    local r = {

    }
    return setmetatable(
        r,
        {
            __index = self,
            __newindex = self
        }
    )
end

function 战斗对象:是否PK()
    return self.战场.脚本 == nil
end

function is_within_one_grid(center_value, target_value)
    -- 示例网格
    local grid = {
        {105, 103, 101, 102, 104},
        {110, 108, 106, 107, 109}
    }
    local rows = #grid
    local cols = #grid[1]
    
    -- 找到中心点的位置
    local center_row, center_col
    for r = 1, rows do
        for c = 1, cols do
            if grid[r][c] == center_value then
                center_row = r
                center_col = c
                break
            end
        end
        if center_row then break end
    end
    
    if not center_row then
        return false  -- 如果中心点不在网格中，返回false
    end
    
    -- 找到目标点的位置
    local target_row, target_col
    for r = 1, rows do
        for c = 1, cols do
            if grid[r][c] == target_value then
                target_row = r
                target_col = c
                break
            end
        end
        if target_row then break end
    end
    
    if not target_row then
        return false  -- 如果目标点不在网格中，返回false
    end
    
    -- 计算中心点和目标点之间的距离
    local row_diff = math.abs(center_row - target_row)
    local col_diff = math.abs(center_col - target_col)
    
    -- 判断是否在一格以内且不包含斜角
    return (row_diff + col_diff == 1)
end

function 战斗对象:取附近一格目标(位置)
    local list = {}
    for k, v in self:遍历我方() do
        if is_within_one_grid(位置,v.位置) then
            table.insert(list, v)
        end
    end
    local sj = math.random(#list)
    return list[sj]
end



function 战斗对象:是否我方(目标)
    if type(目标) == "number" then
        if self.位置 < 101 then
            return 目标 < 101
        else
            return 目标 > 100
        end
    else
        if self.位置 < 101 then
            return 目标.位置 < 101
        else
            return 目标.位置 > 100
        end
    end
end

function 战斗对象:是否敌方(目标)
    if self.位置 < 101 then
        return 目标.位置 > 100
    else
        return 目标.位置 < 101
    end
end

function 战斗对象:遍历敌方()
    if self.位置 < 101 then
        return self.战场:遍历敌方()
    else
        return self.战场:遍历我方()
    end
end

function 战斗对象:遍历我方()
    if self.位置 < 101 then
        return self.战场:遍历我方()
    else
        return self.战场:遍历敌方()
    end
end

function 战斗对象:遍历玩家()
    self.战场:遍历玩家()
end

function 战斗对象:遍历敌方玩家()
    if self.位置 < 101 then
        return self.战场:遍历敌方玩家()
    else
        return self.战场:遍历我方玩家()
    end
end

function 战斗对象:遍历我方玩家()
    if self.位置 < 101 then
        return self.战场:遍历我方玩家()
    else
        return self.战场:遍历敌方玩家()
    end
end

function 战斗对象:遍历敌方存活()
    local list = {}
    for k, v in self:遍历敌方() do
        if not v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方存活()
    local list = {}
    for k, v in self:遍历我方() do
        if not v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历敌方死亡()
    local list = {}
    for k, v in self:遍历敌方() do
        if v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方死亡()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方死亡玩家()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否死亡 and v.是否玩家 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历敌方存活玩家()
    local list = {}
    for k, v in self:遍历敌方() do
        if v.是否玩家 and not v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方存活玩家()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否玩家 and not v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历敌方召唤()
    local list = {}
    for k, v in self:遍历敌方() do
        if v.是否召唤 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方召唤()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否召唤 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:取首目标()
    local 战场 = self.战场
    local 首目标 = self.目标
    local r = 战场:取对象(首目标)
    if r and not r.是否死亡  then
        return r
    end
end

function 战斗对象:取敌方存活(f)
    local list = {}
    for i, v in self:遍历敌方存活() do
        if not f or f ~= v then
            if not v.是否隐身 then
                table.insert(list, v)
            end
        end
    end
    return list
end

function 战斗对象:取敌方存活数()
    return #self:取敌方存活()
end

function 战斗对象:取我方所有(f)
    local list = {}
    for i, v in self:遍历我方() do
        if not f or f ~= v then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:取我方存活(f)
    local list = {}
    for i, v in self:遍历我方存活() do
        if not f or f ~= v then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:取敌方所有(f)
    local list = {}
    for i, v in self:遍历敌方() do
        if not f or f ~= v then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:取我方存活数()
    return #self:取我方存活()
end

function 战斗对象:取物理目标()
    local v = self.战场:取对象(self.目标)
    if v and not v.是否隐身 and not v.是否死亡 and not v:取BUFF('封印') then
        return v
    end
    local list = {}
    local n = 0
    for i, v in self:遍历敌方存活() do
        if not v.是否隐身 and not v.是否死亡 and not v:取BUFF('封印') then
            n = n + 1
            table.insert(list, v)
        end
    end
    if n > 0 then
        return list[math.random(n)]
    end
end

function 战斗对象:随机取物理目标() --分裂
    local list = {}
    for k, v in self:遍历敌方存活() do
        if not v.是否隐身 and not v.是否死亡 and not v:取BUFF('封印') then
            table.insert(list, v)
        end
    end
    if #list > 0 then
        return list[math.random(#list)]
    end
    return false
end

function 战斗对象:取法术目标()
    local 法术 = self.当前法术
    local list
    local 函数 = '取'
    函数 = 函数 .. (法术.敌方可用 and '敌方' or '我方')
    if 法术.敌方可用 and 法术.己方可用 then
        local 首 = self:取首目标()
        if self:是否我方(首) then
            函数 ='取我方'
        else
            函数 ='取敌方'
        end
    end
    函数 = 函数 .. ((法术.死活可用 and '所有') or (法术.存活可用 and '存活') or '死亡')
    local n, fun = 法术:法术取目标数(self)
    if type(n) == 'number' then
        n = self.ev:增加法术目标(n) or n
        if not self[函数] then
            print("函数错误", 法术.名称)
            return list
        end

        -- 孩子增加法术单位写到这里
        for k, _ in pairs(self.孩子增益) do
            if 多目标技能[k] then
                for _k, v in pairs(多目标技能[k]) do
                    if v == 法术.名称 then
                        n = n + 1
                    end
                end
            end
        end

        list = self[函数](self, self:取首目标())
        if type(fun) == 'function' then
            table.sort(list, fun)
        end
        local r = self:取首目标()
        if r  then
            if not r.是否隐身 or (r.是否隐身 and (函数 ~= "取敌方存活" or ((法术.是否仙法 or 法术.是否鬼法) and self.ev:无视隐身()))) then
                table.insert(list, 1, r)
            end
        end
        if not 法术.程府 then
            local i = 1
            repeat
                if list[i] then
                    if list[i]:取BUFF('封印') and not 法术.无视封印 then
                        table.remove(list, i)
                    else
                        i = i + 1
                    end
                end
            until not list[i]
        end
        if fun then
            list = { table.unpack(list, 1, n) }
        elseif #list > 0 then
            local nl = {}

            table.insert(nl, table.remove(list, 1))

            for i = 1, n - 1 do
                if #list > 0 then
                    table.insert(nl, table.remove(list, math.random(#list)))
                end
            end
            list = nl
        end
    else
        list = self[函数](self, 1)
    end

    for i, v in ipairs(list) do
        list[i] = v
    end

    return list
end

function 战斗对象:取我方玩家倒地数量()
    local n = 0
    for k, v in self:遍历我方() do
        if v.是否死亡 and v.是否玩家 then
            n = n + 1
        end
    end
    return n
end

function 战斗对象:删除指定法术(名称)
    for i, v in pairs(self.法术列表) do
        if v.名称 == 名称 then
            self.法术列表[i] = nil
        end
    end
end

function 战斗对象:取是否有终极技能()
    for i, v in pairs(self.法术列表) do
        if v.是否终极 then
            return true
        end
    end
    return false
end

function 战斗对象:遍历我方存活召唤()
    local list = {}
    local 存活 = 0
    for k, v in self:遍历我方() do
        if v.是否召唤 and not v.是否死亡 then
            存活 = 存活 + 1
        end
    end
    return 存活
end

function 战斗对象:取终极技能表()
    local arg = {}
    for i, v in pairs(self.法术列表) do
        if v.是否终极 then
            arg[#arg+1] = v
        end
    end
    return arg
end

function 战斗对象:添加临时技能(技能)
    local  data =  require('lua/对象/法术/技能')({ 名称 = 技能 })
    self.法术列表[data.nid] = data
    return data.名称
end

function 战斗对象:删除指定BUFF(buff)
    if type(buff) == 'string' then
        if self.BUFF列表[buff] then
            self.BUFF列表[buff] = nil
        end
    else
        self.BUFF列表[buff.名称] = nil
    end
end

function 战斗对象:遍历法术()
    return next, self.法术列表
end

function 战斗对象:取BUFF(name)
    return self.BUFF列表[name]
end

function 战斗对象:能否保护()
    for _, v in ipairs { "封印", "昏睡", "混乱" } do
        if self.BUFF列表[v] then
            return false
        end
    end
    return true
end

function 战斗对象:取内丹(name)
    for k, v in pairs(self.内丹列表) do
        if v.名称 == name then
            return v
        end
    end
end

function 战斗对象:进入添加BUFF(buff)
    if  type(buff) ~= 'table' then
        return
    end
    buff = require('战斗/对象/BUFF')(buff, self)
    if buff.名称 and self.ev:BUFF添加前(buff, self) ~= false then
        local o = self.BUFF列表[buff.名称]
        if o then
            o.回合数 = 9999
            o:BUFF回合结束(self)
        end
        self.BUFF列表[buff.名称] = buff
        self.ev:BUFF添加后(buff, self)
        return buff
    end
end

function 战斗对象:进入战斗添加BUFF(buff)
    if not self.当前数据 or type(buff) ~= 'table' then
        return
    end
    buff = require('战斗/对象/BUFF')(buff, self)
    if buff.名称 then
        local o = self.BUFF列表[buff.名称]
        if o then
            o.回合数 = 9999
            o:BUFF回合结束(self)
        end
        self.ev:BUFF添加后(buff, self)
        self.BUFF列表[buff.名称] = buff
        self.当前数据:添加BUFF(buff.id)
        return buff
    end
end

function 战斗对象:添加BUFF(buff)
    if not self.当前数据 or type(buff) ~= 'table' then
        return
    end
    buff = require('战斗/对象/BUFF')(buff, self)
    if buff.名称 and self.ev:BUFF添加前(buff, self) ~= false then
        local o = self.BUFF列表[buff.名称]
        if o then
            o.回合数 = 9999
            o:BUFF回合结束(self)
        end
        self.BUFF列表[buff.名称] = buff
        self.ev:BUFF添加后(buff, self)
        self.当前数据:添加BUFF(buff.id)
        return buff
    end
end

function 战斗对象:删除所有BUFF()
    if not self.当前数据 then
        return
    end
    for i,v in pairs(self.BUFF列表) do
        v:BUFF回合结束(self)
        self.当前数据:删除BUFF(v.id)
        self.BUFF列表[i] = nil
    end
end

function 战斗对象:删除BUFF(buff)
    if not self.当前数据 then
        return
    end
    if type(buff) == 'string' then
        if self.BUFF列表[buff] then
            self.当前数据:删除BUFF(self.BUFF列表[buff].id)
            self.BUFF列表[buff] = nil
        end
    else
        self.当前数据:删除BUFF(buff.id)
        self.BUFF列表[buff.名称] = nil
    end
    self.当前数据.位置 = self.位置
    return true
end


function 战斗对象:直接删除BUFF(buff,wz,tx)
    if not self.当前数据 then
        return
    end
    if type(buff) == 'string' then
        if self.BUFF列表[buff] then
            self.当前数据:删除BUFF(self.BUFF列表[buff].id,wz,tx)
            self.BUFF列表[buff] = nil
        else
            self.当前数据:删除BUFF(buff,wz,tx)
        end
    else
        self.当前数据:删除BUFF(buff.id,wz,tx)
        self.BUFF列表[buff.名称] = nil
    end
    self.当前数据.位置 = self.位置
    return true
end


function 战斗对象:增加气血(v, 特效, ...)
    if not self.当前数据 then
        return
    elseif self.是否死亡 and self:取BUFF('夺魂索命') then
        return
    end
    v = self.ev:BUFF加血前(v) or v
    self.气血 = self.气血 + v
    if self.气血 > self.最大气血 then
        self.气血 = self.最大气血
    end
    if self.是否死亡 then
        self.当前数据:复活(特效)
        self.是否死亡 = false
    end
    self.当前数据:气血(v, ...)
end

function 战斗对象:增加目标气血(v,复活)
    if self.是否死亡  and not 复活 then
        return
    elseif self.是否死亡  and  复活 and self:取BUFF('夺魂索命') then
        return
    end
    self.气血 = self.气血 + v
    if self.气血>self.最大气血 then
        self.气血=self.最大气血
    end
    return true
end

function 战斗对象:增加目标魔法(v)
    if self.是否死亡 then
        return
    end
    self.魔法 = self.魔法 + v
    if self.魔法>self.最大魔法 then
        self.魔法=self.最大魔法
    end
    return true
end

function 战斗对象:减少气血(v, ...)
    if not self.当前数据 then
        return
    end
    self.气血 = self.气血 - v
    self.当前数据:气血(-v, ...)

    if self.气血 <= 0 then
        self.气血 = 0
        self.是否死亡 = true
    end

    if self.是否死亡 then
        if self.是否消失 then
            self.战场:退出(self.位置)
        end
        self.当前数据:死亡(self.是否消失)
    end
end

function 战斗对象:增减气血(v)
    if not self.当前数据 then
        return
    end
    if v >= 0 then
        self:增加气血(v)
    else
        self:减少气血(v)
    end
    return true
end

function 战斗对象:增加魔法(v, ...)
    if not self.当前数据 then
        return
    end
    self.魔法 = self.魔法 + v > self.最大魔法 and self.最大魔法 or self.魔法 + v
    self.当前数据:魔法(v, ...)
end

function 战斗对象:减少魔法(v, ...)
    if not self.当前数据 then
        return
    end
    self.魔法 = self.魔法 - v
    self.当前数据:魔法(-v, ...)

    if self.魔法 <= 0 then
        self.魔法 = 0
    end
end

function 战斗对象:可视增加魔法(v,s)
    if not self.当前数据 then
        return
    end
    self.魔法 = self.魔法 + v
    if not s then
        self.当前数据:魔法(v, 2)
    end
    if self.魔法 > self.最大魔法 then
        self.魔法 = self.最大魔法
    end
end

function 战斗对象:可视减少魔法(v)
    if not self.当前数据 then
        return
    end
    self.魔法 = self.魔法 - v
    self.当前数据:魔法(-v, 2)

    if self.魔法 <= 0 then
        self.魔法 = 0
    end
end

function 战斗对象:增减魔法(v)
    if not self.当前数据 then
        return
    end
    if v >= 0 then
        self:增加魔法(v, 1)
    else
        self:减少魔法(v, 1)
    end
end

function 战斗对象:增加怨气(v, 特效, ...)
    if not self.当前数据 then
        return
    end
    self.怨气 = self.怨气 + v
    if self.怨气 > self.最大怨气 then
        self.怨气 = self.最大怨气
    end
    -- self.当前数据:怨气(self.怨气, ...)
end

function 战斗对象:减少怨气(v, 特效, ...)
    if not self.当前数据 then
        return
    end
    self.怨气 = self.怨气 - v
    if self.怨气 > self.最大怨气 then
        self.怨气 = self.最大怨气
    end
    self.当前数据:怨气(self.怨气, ...)
end

function 战斗对象:取魔法()
    return self.魔法
end

function 战斗对象:取气血()
    return self.气血
end

function 战斗对象:取怨气()
    return self.怨气
end

function 战斗对象:双加(a, b)
    if not self.当前数据 then
        return
    end
    if a >= 0 then
        self:增加气血(a)
        self:增加魔法(b)
    else
        self:减少气血(a)
        self:减少魔法(b)
    end
end

function 战斗对象:提示(内容)
    if not self.当前数据 then
        return
    end
    --self.当前数据.位置 = self.位置
    self.当前数据:提示(内容)
end

function 战斗对象:我方总目标数() --混乱
    local 数量 = 0
    local list = {}
    for k, v in self:遍历我方() do
        数量 = 数量 + 1
    end
    return 数量
end



function 战斗对象:随机敌方玩家存活目标() --混乱
    local list = {}
    for k, v in self:遍历敌方() do
        if not v.是否死亡 and not v:取BUFF('封印') and v.是否玩家 then
            table.insert(list, v)
        end
    end
    if #list > 0 then
        return list[math.random(#list)].位置
    end
    return 0
end

function 战斗对象:随机我方未封印目标() --混乱
    local list = {}
    for k, v in self:遍历我方() do
        if not v.是否死亡 and not v:取BUFF('封印') and not v:取BUFF('混乱')  then
            table.insert(list, v)
        end
    end
    return #list
end


function 战斗对象:随机我方存活目标() --混乱
    local list = {}
    for k, v in self:遍历我方() do
        if not v.是否死亡 then
            table.insert(list, v)
        end
    end
    if #list > 0 then
        return list[math.random(#list)].位置
    end
end

function 战斗对象:随机敌方存活目标() --混乱
    local list = {}
    for k, v in self:遍历敌方() do
        if not v.是否死亡 then
            table.insert(list, v)
        end
    end
    if #list > 0 then
        return list[math.random(#list)].位置
    end
    return 0
end

function 战斗对象:随机敌方(n, fun)
    local list = {}
    for k, v in self:遍历敌方() do
        if not fun or fun(v) then
            table.insert(list, v)
        end
    end
    if #list > 0 and n > 0 then
        if n == 1 then
            return { list[math.random(#list)] }
        else
            while #list > n do
                table.remove(list, math.random(#list))
            end
            return list
        end
    end
    return {}
end

function 战斗对象:敌方属性排列(n, fun,fun2)
    local list = {}
    for k, v in self:遍历敌方() do
        if not fun or fun(v) then
            table.insert(list, v)
        end
    end
    if #list > 0 and n > 0 then
        if n == 1 then
            return { list[math.random(#list)] }
        else
            while #list > n do
                table.remove(list, #list)
            end
            return list
        end
    end
    return {}
end

function 战斗对象:我方属性排序(n, fun, fun2)
    local list = {}
    for k, v in self:遍历我方() do
        if not fun or fun(v) then
            table.insert(list, v)
        end
    end
    if type(fun2) == 'function' then
        table.sort(list, fun2)
    end
    if #list > 0 and n > 0 then
        if n == 1 then
            return { list[math.random(#list)] }
        else
            while #list > n do
                table.remove(list, math.random(#list))
            end
            return list
        end
    end
    return {}
end

function 战斗对象:随机我方(n, fun)
    local list = {}
    for k, v in self:遍历我方() do
        if not fun or fun(v) then
            table.insert(list, v)
        end
    end
    if #list > 0 and n > 0 then
        if n == 1 then
            return { list[math.random(#list)] }
        else
            while #list > n do
                table.remove(list, math.random(#list))
            end
            return list
        end
    end
    return {}
end

function 战斗对象:取我方死亡玩家(n, 是否先主人) -- 黄泉一笑
    local list = {}
    local 主人 = nil
    for k, v in self:遍历我方死亡玩家() do
        if v.nid == self.对象.主人.nid then
            主人 = v
        end
        table.insert(list, v)
    end
    if #list > 0 and n > 0 then
        if n == 1 then
            if 是否先主人 and 主人 then
                return { 主人 }
            end
            return { list[math.random(#list)] }
        else
            while #list > n do
                table.remove(list, math.random(#list))
            end
            return list
        end
    end
    return {}
end


function 战斗对象:取群体物理目标(sl)
    local list = {}
    local v = self.战场:取对象(self.目标)

    -- 检查主要目标是否符合条件
    if v and not v.是否隐身 and not v.是否死亡 and not v:取BUFF('封印') then
        list[#list+1] = {v, 100}
    end

    -- 遍历所有存活的敌方单位，并将其添加到列表中（如果符合条件）
    for _, enemy in self:遍历敌方存活() do
        if not enemy.是否隐身 and not enemy.是否死亡 and not enemy:取BUFF('封印') then
            -- 确保主要目标不会被重复添加
            if #list == 0 or enemy ~= list[1][1] then
                list[#list+1] = {enemy, math.random(50)}
            end
        end
    end

    -- 根据第二个值降序排序列表
    table.sort(list, function(a, b) return a[2] > b[2] end)

    -- 创建一个新的表来存储选中的目标
    local tab = {}
    for i = 1, math.min(#list, sl) do
        tab[#tab+1] = list[i][1]
    end

    return tab
end

function 战斗对象:所满足对象(fun,func)
    local list = {}
    for k, v in self:遍历敌方() do
        if not fun or fun(v) then
            table.insert(list, v)
        end
    end
    for k, v in self:遍历我方() do
        if not fun or fun(v) then
            table.insert(list, v)
        end
    end
    -- 打乱列表顺序
    for i = #list, 2, -1 do
        local j = math.random(i)
        list[i], list[j] = list[j], list[i]
    end
    return list
end

function 战斗对象:取我方魔法低于_百分比(bl)
    local list = {}
    for k, v in self:遍历我方() do
        if (v.魔法/v.最大魔法) <= bl then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:取召唤信息(位置)
    for k, v in self:遍历我方() do
        if v.位置 == 位置 then
            return v
        end
    end
end

function 战斗对象:取我方死亡()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否死亡 and v.是否玩家 then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:添加特效(v,位置)
    if not self.当前数据 then
        return
    end
    self.当前数据:添加特效(v,位置)
end


local function 判断位置(位置,目标位置)
    if 位置 == 101 then
        目标编号组 = {位置+1,位置+2,位置+5,位置+5+1,位置+5+2}
    elseif 位置 == 106 then
        目标编号组 = {位置+1,位置+2,位置-5,位置-5+1,位置-5+2}
    elseif 位置 == 102 then
        目标编号组 = {位置+2,位置-1,位置+5,位置+5-2,位置+5-1}
    elseif 位置 == 107 then
        目标编号组 = {位置+2,位置-1,位置-5,位置-5+2,位置-5-1}
    elseif 位置 == 104 then
        目标编号组 = {-1,位置-2,位置+5,-1,位置+5-2}
    elseif 位置 == 109 then
        目标编号组 = {-1,位置-2,位置-5,-1,位置-5-2}
    elseif 位置 == 103 then
        目标编号组 = {位置-2,位置+2,位置+5,位置+5-2,位置+5+2}
    elseif 位置 == 108 then
        目标编号组 = {位置-2,位置+2,位置-5,位置-5-2,位置-5+2}
    elseif 位置 == 105 then
        目标编号组 = {位置-2,-1,位置+5,位置+5-2,-1}
    elseif 位置 == 110 then
        目标编号组 = {位置-2,-1,位置-5,位置-5-2,-1}
    end
    for i,v in pairs(目标编号组) do
        if 目标位置 == v and 目标位置 ~= 位置 then
            return true
        end
    end
    return false
end

function 战斗对象:取附近目标(位置)
    local list = {}
    for k, v in self:遍历我方() do
        if 判断位置(位置,v.位置) then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:取我方指定模型单位(造型,wz)
    local 位置 = 0
    for k, v in self:遍历我方() do
        if v.外形 == 造型 and v.位置 ~= wz then
            位置 = v.位置
            break
        end
    end
    return 位置
end
