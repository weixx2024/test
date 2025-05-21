local 角色 = require('角色')

function 角色:好友_初始化()
    self:上线事件()
end

function 角色:上线事件()
    --获取在线的好友
    --告诉在线的好友 我上线了
    for nid, _ in self:遍历好友() do
        if __玩家[nid] then
            __玩家[nid].rpc:聊天框提示("#Y你的好友#G%s#Y上线了", self.名称)
        end
    end
end

function 角色:遍历好友()
    return next, self.好友列表
end

function 角色:角色_添加好友(nid)
    -- if self.转生 == 0 and self.等级 < 50 then
    --     self.rpc:提示窗口('#R50级以后才能添加好友')
    --     return
    -- end

    if self.好友列表[nid] then
        self.rpc:常规提示("#Y对方已经是你的好友了")
        return
    end
    if nid == self.nid then
        return
    end
    local P = __玩家[nid]
    local 状态 = "在线"
    if not P then
        -- P = __存档:按nid查询角色(nid)--todo 离线添加
        -- 状态 = "离线"
        self.rpc:常规提示("#Y该角不在线")
        return
    end
    if not P then
        self.rpc:常规提示("#Y该角色不存在")
        return
    end
    if self:取好友数量() >= 50 then
        self.rpc:常规提示("#Y好友列表已满")
        return
    end
    self.好友列表[nid] = {
        nid = P.nid,
        id = P.id,
        称谓 = P.称谓,
        名称 = P.名称,
        转生 = P.转生,
        等级 = P.等级,
        种族 = P.种族,
        帮派 = P.帮派,
        头像 = P.头像,
        关系 = 0, --0陌生人 1普通
        好友度 = 0,
        连发 = 0,
        更新时间 = os.time(),
        获得时间 = os.time(),
        状态 = 状态,
    }
    self.rpc:常规提示("#Y添加成功！")
    if 状态 == "在线" then
        P.rpc:常规提示("#G%s#Y将你添加为好友！", self.名称)
        if P:好友验证(self.nid) then
            self.好友列表[nid].关系 = 1
        end
    end
    self.rpc:刷新好友列表()
end

function 角色:角色_获取好友属性(nid)
    if self.好友列表[nid] then
        return self.好友列表[nid]
    end
end

function 角色:好友验证(nid) --用于区别关系 双方都有为好友 esle 陌生人
    if self.好友列表[nid] then
        if self.好友列表[nid].关系 == 0 then
            self.好友列表[nid].关系 = 1
        end
        return true
    end
end

function 角色:角色_获取好友列表()
    local list = {}
    for _, v in self:遍历好友() do
        if not v.获得时间 then
            self.好友列表[v.nid] = nil
        end
        local P = __玩家[v.nid]
        local 状态 = "离线"
        if P then
            状态 = "在线"
        end
        table.insert(list, { nid = v.nid, 名称 = v.名称, 获得时间 = v.获得时间, 状态 = 状态 })
    end
    return list
end

function 角色:取好友数量()
    local n = 0
    for k, v in self:遍历好友() do
        n = n + 1
    end
    return 0
end

function 角色:角色_好友查询(t)
    local id = tonumber(t[1])
    local name = t[2]
    local tt
    local ttt
    if name ~= "" then
        tt = __存档.按ID查询角色(name)
    end
    if id then
        tt = __存档.按ID查询角色(id - 10000)
    end
    if tt then
        return {
            名称 = tt.名称,
            nid = tt.nid,
            id = tt.id + 10000,
            转生 = tt.转生,
            头像 = tt.头像,
            等级 = tt.等级,
            种族 = tt.种族,
            性别 = tt.性别,
        }
    end
    return "#Y 查询不到该角色"
end

function 角色:角色_获取指定消息(nid)
    if __消息列表[self.nid] and __消息列表[self.nid][nid] then
        local t = __消息列表[self.nid][nid][1]
        if t then
            table.remove(__消息列表[self.nid][nid], 1)
            if #__消息列表[self.nid][nid] == 0 then
                __消息列表[self.nid][nid] = nil
            end
            return t
        end
    end
    return 1
end

function 角色:角色_发送好友信息(t)
    local nid = t[1]
    if not __消息列表[nid] then
        __消息列表[nid] = {}
    end
    if not __消息列表[nid][self.nid] then
        __消息列表[nid][self.nid] = { name = self.名称 }
    end
    --todo 连发 3条   累计自己连发 清空对方给自己的连发         限制回复后才可以继续发 防止恶意刷
    table.insert(__消息列表[nid][self.nid], { time = os.time(), txt = t[2] })
    if __玩家[nid] then
        __玩家[nid].rpc:界面消息_好友(self.nid)
    end
end

function 角色:角色_点击好友按钮()
    if not __消息列表[self.nid] then
        __消息列表[self.nid] = {}
    end
    local n = 0
    local t
    for k, v in pairs(__消息列表[self.nid]) do
        if #v > 0 then
            n = n + 1
            if not t then
                t = { 名称 = v.name, nid = k }
            end
            if n > 1 then
                break
            end
        end
    end
    return t, n > 1
end

function 角色:角色_好友删除(nid)
    if self.好友列表[nid] then
        self.好友列表[nid] = nil
        return true
    end
end

function 角色:角色_更新好友信息(nid)
    local P = __玩家[nid]
    if not P then
        self.rpc:常规提示("#Y该角色不在线")
        return
    end
    if not self.好友列表[nid] then
        self.rpc:常规提示("#Y该玩家不是你的好友")
        return
    end



    if os.time() - self.好友列表[nid].更新时间 < 60 then
        self.rpc:常规提示("#Y请勿频繁操作 一分后再尝试")
        return
    end






    for _, v in pairs { "nid", "id", "称谓", "名称", "转生", "等级", "种族", "帮派", "头像", "id" } do
        self.好友列表[nid][v] = P[v]
    end
    return true
end

function 角色:好友_拉黑(nid)
    if self.好友列表[nid] then
        self.好友列表[nid] = nil
    end
    self.黑名单[nid] = true
end
