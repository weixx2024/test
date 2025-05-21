local 取信息表 = function(list, keys)
    local t = {}
    if type(list) ~= "table" then
        return t
    end
    for i, v in ipairs(list) do
        t[i] = {}
        for _, k in ipairs(keys) do
            t[i][k] = v[k]
        end
    end
    return t
end

local _刷新界面信息 = function(self)
    local t = 取信息表(self.队伍, { 'nid', "id", '头像', '名称', '等级', '种族', '性别' })
    for k, v in self:遍历队伍() do
        v.rpc:界面信息_队伍(t)
    end
end

local _添加队伍成员 = function(self, P)
    if self.队伍 then
        table.insert(self.队伍, P)
    end
end

local _删除队伍成员 = function(self, P)
    if self.队伍 then
        for i, v in ipairs(self.队伍) do
            if v.nid == P.nid then
                table.remove(self.队伍, i)
                return true
            end
        end
    end
end

local _刷新队伍信息 = function(self)
    if self.队伍 then
        for i, v in ipairs(self.队伍) do
            v:刷新队伍信息()
        end
    end
end


local _队伍移交队长 = function(self, P)
    if self.队伍 then
        for i, v in ipairs(self.队伍) do
            if v.nid == P.nid then
                self.队伍[1] = v
                self.队伍[i] = self
                return true
            end
        end
    end
end

local _删除队伍申请 = function(self, P)
    if self.队伍申请 then
        for i, v in ipairs(self.队伍申请) do
            if v.nid == P.nid then
                table.remove(self.队伍申请, i)
                return true
            end
        end
    end
end

local _添加队伍申请 = function(self, P)
    if self.队伍申请 then
        table.insert(self.队伍申请, P)
    end
end

local _重置队伍信息 = function(self)
    self.队伍 = nil
    self.是否组队 = nil
    self.是否队长 = nil
    self.队伍申请 = nil

    self.队长 = nil
    self.队友 = {}
    self.队伍位置 = nil
end

local _更新地图状态 = function(self, flag)
    if flag then
        self.rpc:添加状态(self.nid, 'leader') --自己
        self.rpn:添加状态(self.nid, 'leader') --周围
    else
        self.rpc:删除状态(self.nid, 'leader') --自己
        self.rpn:删除状态(self.nid, 'leader') --周围
    end
end

local _刷新地图队友 = function(self)
    if self.队伍 then
        local 队长 = self.队伍[1]
        if 队长 then
            local 队友 = 队长:取队友()
            self.rpc:置队友(队长.nid, 队友) --自己
            self.rpn:置队友(队长.nid, 队友) --周围
        end
    end
end

local 角色 = require('角色')

function 角色:队伍_初始化()
end

function 角色:刷新队伍信息()
    self.队长 = nil
    self.队友 = {}
    self.队伍位置 = nil
    for i, v in self:遍历队伍() do
        if v.是否队长 then
            self.队长 = v.nid
        end
        if v.nid == self.nid then
            self.队伍位置 = i --自己位置
        else
            table.insert(self.队友, v.nid)
        end
    end
end

function 角色:取队长()
    if self.队伍 and self.队伍[1] then
        return __玩家[self.队伍[1].nid]
    end
end

function 角色:取队友()
    if self.队伍 then
        local r = {}
        for _, v in self:遍历队友() do
            table.insert(r, v.nid)
        end
        return r
    end
end

function 角色:取队伍成员(nid)
    if self.队伍 then
        for _, v in ipairs(self.队伍) do
            if v.nid == nid then
                return v
            end
        end
    end
end

function 角色:取队伍申请(nid)
    if self.队伍申请 then
        for _, v in ipairs(self.队伍申请) do
            if v.nid == nid then
                return v
            end
        end
    end
end

function 角色:取队伍人数()
    if type(self.队伍) == 'table' then
        return #self.队伍
    end
    return 0
end

function 角色:是否队友(P)
    if self.是否组队 then
        for _, v in ipairs(self.队伍) do
            if v == P then
                return true
            end
        end
    end
end

function 角色:遍历队伍()
    if self.是否组队 then
        return next, self.队伍
    end
    return next, { self }
end

-- 队友不包括自己
function 角色:遍历队友()
    if self.是否组队 then
        local k, v
        return function(list)
            k, v = next(list, k)
            if v == self then
                k, v = next(list, k)
            end
            return k, v
        end, self.队伍
    end
    return next, {}
end

function 角色:队伍_取队伍人数()
    return #self.队伍
end

function 角色:角色_打开队伍窗口()
    if self.是否组队 then
        return 取信息表(self.队伍, { 'nid', '外形', '名称', '等级', '种族', '性别' })
    end
end

function 角色:角色_打开队伍申请窗口()
    if self.是否组队 then
        return 取信息表(self.队伍申请, { 'nid', '名称', '等级', '种族', '性别' })
    end
end

function 角色:角色_创建队伍()
    if self.是否战斗 or self.是否组队 then
        return
    end

    self.是否组队 = true
    self.是否队长 = true
    self.队伍 = {}
    self.队伍申请 = {}
    _添加队伍成员(self, self)
    _刷新队伍信息(self) --刷新
    _刷新界面信息(self) --队友
    _更新地图状态(self, true)
    return true
end

function 角色:角色_解散队伍()
    if self.是否战斗 then
        return
    end
    if not self.是否队长 then
        return
    end
    self.rpc:提示窗口('#Y队伍解散了。')
    self.rpt:提示窗口('#Y队伍解散了。')
    for _, v in self:遍历队伍() do
        _重置队伍信息(v) --自己
        v.rpc:界面信息_队伍({})
    end
    _更新地图状态(self, false)
    if self.助战列表 and next(self.助战列表) ~= nil then
        for k, v in pairs(self.助战列表) do
            if v then
                self.助战列表[k] = false
                self:角色_助战下线(k)
            end
        end
    end
    return true
end

function 角色:角色_离开队伍()
    if self.是否战斗 then
        return
    end
    if self.是否队长 then
        return
    end
    if not self.是否组队 then
        return
    end
    self.rpc:提示窗口('#Y你离开了队伍。') --自己
    self.rpt:提示窗口('#R%s#Y离开了队伍。', self.名称) --队友
    _删除队伍成员(self, self)
    _刷新队伍信息(self) --刷新
    _刷新界面信息(self) --队友
    _刷新地图队友(self) --地图
    _重置队伍信息(self) --自己
    self.rpc:界面信息_队伍({})
    return true
end

function 角色:角色_踢出队伍(nid)
    if self.是否战斗 then
        return
    end
    if not self.是否队长 then
        return
    end
    if nid == self.nid then
        return -- 不能T自己
    end
    local P = self:取队伍成员(nid)
    if not P then
        return
    end
    _删除队伍成员(self, P)
    _重置队伍信息(P)
    P.rpc:界面信息_队伍({})
    P.rpc:提示窗口('#Y你被请离了队伍。')
    _刷新队伍信息(self) --刷新
    _刷新界面信息(self) --队友
    _刷新地图队友(self) --地图
    if P.是否助战 then
        P:踢下线()
    end
    return true
end

---
function 角色:角色_踢出队伍NID(NID)
    if self.是否组队 and not self.是否战斗 and self.是否队长 and NID ~= self.nid then
        local P = self:取队伍成员(NID)
        if P then
            _删除队伍成员(self, P)
            _重置队伍信息(P)
            P.rpc:界面信息_队伍({})
            P.rpc:提示窗口('#Y你被请离了队伍。')
            _刷新队伍信息(self) --刷新
            _刷新界面信息(self) --队友
            _刷新地图队友(self) --地图
            __玩家[NID]:踢下线()
            return true
        elseif __玩家[NID] then
            local 角色数据  =  __存档.角色列表(self.nid)
            for i,v in pairs(角色数据) do
                if v.nid == NID then
                    __玩家[NID]:踢下线()
                    return true
                end
            end
        end
    elseif NID ~= self.nid and __玩家[NID] then
        local 角色数据  =  __存档.角色列表(self.nid)
            for i,v in pairs(角色数据) do
                if v.nid == NID then
                    __玩家[NID]:踢下线()
                    return true
                end
            end
        return true
    end
end

function 角色:角色_移交队长(nid)
    if self.当前地图.名称 == '龙神比武场' and self.帮战状态 then
        self.rpc:提示窗口('#Y帮战中不得移交队长')
        return
    end
    if self.是否战斗 then
        return
    end
    if not self.是否队长 then
        return
    end
    if nid == self.nid then
        return -- 不能T自己
    end
    
    local P = self:取队伍成员(nid)
    if not P then
        return
    end
    if P.是否助战 then
        self.rpc:提示窗口('#Y助战只可以通过切换来进行修改队长')
        return
    end
    local 助战
    for i, v in self:遍历队伍() do
        if v.是否助战 then
            助战 = true
            break
        end
    end
    if P.账号 ~= self.账号 and  助战 then
        self.rpc:提示窗口('#Y队伍中存在你的助战，无法将队长转移给他人')
        return
    end
    P.是否队长 = self.是否队长
    P.队伍申请 = self.队伍申请
    P.rpc:提示窗口('#Y你成为了新的队长。')
    self.是否队长 = nil --清空
    self.队伍申请 = nil --清空
    _队伍移交队长(self, P) --移交队长
    _更新地图状态(self, false)
    _更新地图状态(P, true) --新队长
    _刷新队伍信息(self) --刷新
    _刷新界面信息(self) --队友
    _刷新地图队友(self) --地图
    return true
end

function 角色:角色_助战切换(id, 切换前nid)
    local 助战列表 = {}
    local 助战 = __玩家[切换前nid]
    if 助战 then
        -- 助战:角色_移动结束(助战.x, 助战.y, 助战.方向)
        助战.cid = nil
        助战.是否助战 = true
        助战.是否队长, self.是否队长 = nil, true
        self.队伍申请 = 助战.队伍申请
        self.rpc:提示窗口('你成为了新的队长。')
        self.队友 = {}
        for i, v in self:遍历队伍() do
            if v.nid == self.nid then
                self.队长 = v.nid
                self.队伍[1], self.队伍[i] = self.队伍[i], self.队伍[1]
            else
                v.是否队长 = nil
            end
            if v.nid == self.nid then
                self.队伍位置 = i --自己位置
            else
                table.insert(self.队友, v.nid)
            end
        end
        助战.队伍申请 = nil
        if 助战.助战列表 then
            助战列表 = 助战.助战列表
            助战.助战列表 = nil
        end
    end
    self.cid = id --网络
    self.可刷新 = false
    self.rpc:切换助战(self:取登录数据(), self.设置)
    self.更新时间 = os.time()
    self.可刷新 = true
    self.交易锁 = true
    self.离线摆摊 = nil
    self.是否助战 = false
    self.助战列表 = 助战列表
    self.助战列表[self.nid] = false
    self.助战列表[切换前nid] = true
    if self.观看召唤 then
        self.观看召唤:召唤_观看(true)
    end
    if self.观看宠物 then
        self.观看宠物:宠物_观看(true)
    end

    -- self.task:任务上线(self.接口)
    self.rpc:刷新任务追踪()
    self:地图_初始化对象()
    self:角色_刷新外形()
    _更新地图状态(self, false)
    _更新地图状态(self, true) --新队长
    _更新地图状态(助战, false) --新队长
    _刷新队伍信息(self) --刷新
    _刷新界面信息(self) --队友
    _刷新地图队友(self) --地图
    if self.是否交易  and self.交易对象 then
        self.rpc:交易窗口(self.交易对象.名称, self.银子, self:交易_取召唤())
    end
    -- if self.是否战斗 then
    --     if self.战斗 then
    --         self.rpc:切换助战位置(self.战斗.位置)
    --         if self.战斗.战场.阶段 == 3 then
    --             if self.战斗.完成指令 == false then
    --                 self.战斗:打开菜单()
    --             else
    --                 self.rpc:助战关闭人物战斗菜单()
    --                 self.rpc:助战关闭召唤战斗菜单()
    --             end
    --         end
    --         if self.战斗.自动 then
    --             self.rpc:助战切换战斗自动(self:角色_战斗自动(true))
    --         else
    --             self.rpc:助战关闭战斗自动()
    --         end
    --     end
    -- end

    -- -- 处理战斗与战斗外 互切
    -- if 助战.是否战斗 and not self.是否战斗 then
    --     self.rpc:退出战斗()
    --     self.rpc:助战关闭战斗自动()
    -- end

    -- if not 助战.是否战斗 and self.是否战斗 then
    --     local 位置 = self.战斗.位置
    --     local 回合数 = self.战斗.战场.回合数
    --     local data = self.战斗.战场:取数据(位置)
    --     local 数据 = self.战斗.战场._数据
    --     self.rpc:进入战斗(data, 位置, 回合数, false, 数据)
    -- end
    return true
end



function 角色:角色_申请加入队伍(nid)
    if self.是否组队 then
        return
    end
    if self.是否战斗 or self.是否摆摊 then
        return
    end
    local P = self.周围玩家[nid]
    if not P then
        return '#R对方距离过远'
    end
    if __副本地图[self.当前地图.接口.id] and self.当前地图.接口.名称 == '龙神比武场' then
        if P and P.是否组队 and P.是否队长 and __玩家[P.nid] then
            if self.帮派 ~= __玩家[P.nid].帮派 then
                return '#Y帮战中禁止加入敌方队伍!'
            end
        end
    elseif __水陆大会 and self.当前地图.接口.id == __水陆大会.地图.id  then
        if __水陆大会.报名数据[self.nid].队伍 ~=  __水陆大会.报名数据[P.nid].队伍 then
            return '#Y这不是你的队伍!'
        end
    end

    if not P.是否组队 then
        return '#R对方没有队伍'
    end
    -- 不是队长，找到队长
    if not P.是否队长 then
        for k, v in pairs(P.队伍) do
            if v.是否队长 then
                P = v -- 找到队长
            end
        end
    end
    if P then
        if P:取队伍申请(self.nid) then
            return '#Y你已在对方的申请列表中...'
        end
        if P:取队伍人数() >= 5 then
            return '#R该队伍已经满员。'
        end
        _添加队伍申请(P, self)
        P.rpc:界面消息_队伍() -- 按钮动画
        return '#Y已经向队长申请加入...'
    end
    return '#R无法加入'
end

function 角色:角色_允许加入队伍(nid)
    if not self.是否队长 then
        return
    end
    local P = self:取队伍申请(nid)

    if not P then
        return
    end
    if self:取队伍人数() >= 5 then
        return '#R队伍已经满员了。'
    end
    if P.是否组队 then
        return '#R对方已经有队伍了'
    end
    if P.是否战斗 or P.是否摆摊 then
        return '#R对方当前状态无法组队'
    end
    if not self.周围玩家[nid] then
        return '#R对方距离过远'
    end
    if not __玩家[P.nid] then
        return '#R对方不在线'
    end
    _删除队伍申请(self, P)
    P.是否组队 = true
    P.队伍 = self.队伍
    _添加队伍成员(self, P)
    _刷新队伍信息(self) --刷新
    _刷新界面信息(self) --队友
    _刷新地图队友(self) --地图
    P:角色_自动归队()
    return true
end

function 角色:角色_快速加入队伍(nid)
    if not self.是否组队 or not self.是否队长 then
        return '#R只有队长才可进行此操作'
    elseif self:取队伍人数() >= 5 then
        return '#R队伍已经满员了。'
    end
    if self.nid == nid then
        return '#R你无法这样操作自己'
    end
    if not __玩家[nid] then
        return '#R对方不在线'
    end
    if __玩家[nid].是否组队 then
        return '#R对方已经有队伍了'
    end
    if __玩家[nid].是否战斗 or __玩家[nid].是否摆摊 then
        return '#R对方当前状态无法组队'
    end
    __玩家[nid].是否组队 = true
    __玩家[nid].队伍 = self.队伍
    _添加队伍成员(self, __玩家[nid])
    _刷新队伍信息(self) --刷新
    _刷新界面信息(self) --队友
    _刷新地图队友(self) --地图
    __玩家[nid]:角色_自动归队()
    return true
end

function 角色:角色_拒绝加入队伍(nid)
    if not self.是否队长 then
        return
    end
    if not self.队伍申请 then
        return
    end
    local P = self:取队伍申请(nid)
    if not P then
        return
    end
    _删除队伍申请(self, P)
    P.rpc:提示窗口('#G%s#Y拒绝了你的组队请求', self.名称)
    return true
end

function 角色:角色_清空申请队伍()
    if self.是否组队 and self.是否队长 then
        self.队伍申请 = {}
        return true
    end
end

function 角色:队伍_添加助战(P)
    if __玩家[P.nid] then
        P.是否组队 = true
        P.队伍 = self.队伍
        _添加队伍成员(self, P)
        _刷新队伍信息(self) --刷新
        _刷新界面信息(self) --队友
        _刷新地图队友(self) --地图
    end
end

function 角色:队伍_添加机器人(P)
    if __机器人[P.nid] then
        P.是否组队 = true
        P.队伍 = self.队伍
        _添加队伍成员(self, P)
        _刷新队伍信息(self) --刷新
        _刷新界面信息(self) --队友
        _刷新地图队友(self) --地图
    end
end

function 角色:队伍重新上线()
    if not self.队伍 then
        return
    end
    if self.是否助战  then
        self:角色_离开队伍()
        self.是否助战 = nil
    else
        _刷新界面信息(self)
    end
end

function 角色:取水陆总积分()
    return self.其它.水陆总积分
end

function 角色:取队伍水陆积分()
    local n = 0
    for i, P in self:遍历队伍() do
        n = n + P:取水陆总积分()
    end
    return n
end
