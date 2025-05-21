local _存档表 = require('数据库/存档属性_帮派')
local 帮派 = class('帮派')

gge.require('对象/帮派/数据')
gge.require('对象/帮派/操作')
gge.require('对象/帮派/地图')
function 帮派:帮派(t)
    self:加载存档(t)
    self.接口 = require('对象/帮派/接口')(self)
    if not self.nid then
        self.nid = __生成ID()
    end
    --__帮派[self.nid] = self
    __帮派[self.名称] = self


    self.rpc =
        setmetatable(
            {},
            {
                __index = function(_, k)
                    return function(_, ...)
                        local arg = { ... }
                        local list = {}
                        for k, v in self:遍历成员() do
                            if __玩家[k] then
                                list[k] = __玩家[k]
                            end
                        end
                        coroutine.xpcall(
                            function()
                                local n = 0
                                for _, v in pairs(list) do
                                    v.rpc[k](nil, table.unpack(arg))
                                    n = n + 1
                                    if n % 50 == 0 then --发送50个玩家，停一下
                                        __世界:定时(100)
                                    end
                                end
                            end
                        )
                    end
                end
            }
        )
end

function 帮派:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 帮派:__newindex(k, v)
    if _存档表[k] ~= nil then
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 帮派:加载存档(t)
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
    else
        rawset(self, '数据', t)
        self.成员列表 = {}
    end
end

function 帮派:取存档数据()
    local r = {
        nid = self.nid,
        名称 = self.名称,
        帮主 = self.帮主,
        等级 = self.等级,
    }
    r.数据 = GGF.复制表(self.数据)
    return r
end

function 帮派:进入地图(P)
    if not self.地图 then
        if self.等级 == 1 then
            self:创建初级帮派地图()
        elseif self.等级 == 4 then
            self:创建高级帮派地图()
        else
            self:创建中级帮派地图()
        end
    end
    --判断队友
    P:移动_切换地图(self.地图, 3060, 2090)
end

function 帮派:遍历成员()
    return next, self.成员列表
end

function 帮派:打开帮派管理(nid)
    return self:取成员列表(nid), self:取申请列表(nid), self:取成员权限(nid)
end

function 帮派:成员上线(P)
    if self.成员列表[P.nid] then
        self.成员列表[P.nid].等级 = P.等级
        self.成员列表[P.nid].转生 = P.转生
        self.成员列表[P.nid].外形 = P.原形
        self.成员列表[P.nid].性别 = P.性别
        self.成员列表[P.nid].种族 = P.种族
        self.成员列表[P.nid].称谓 = P.称谓
        self.成员列表[P.nid].状态 = '在线'
        if self.成员列表[P.nid].帮派进场 and self.成员列表[P.nid].帮战奖励 then
            self.成员列表[P.nid].帮派进场 = nil
            if self.成员列表[P.nid].帮战奖励 == 1 then
                self.成员列表[P.nid].帮战奖励 = nil
                __帮战:胜利奖励(P.接口)
            else
                self.成员列表[P.nid].帮战奖励 = nil
                __帮战:失败奖励(P.接口)
            end
        end
        --帮派信息
        self:帮派信息("成员#G%s#W上线了", P.名称)
        return true
    end
end

function 帮派:成员下线(P)
    if self.成员列表[P.nid] then
        self.成员列表[P.nid].等级 = P.等级
        self.成员列表[P.nid].转生 = P.转生
        self.成员列表[P.nid].外形 = P.原形
        self.成员列表[P.nid].性别 = P.性别
        self.成员列表[P.nid].种族 = P.种族
        self.成员列表[P.nid].称谓 = P.称谓
        self.成员列表[P.nid].状态 = '离线'
        self.成员列表[P.nid].离线时间 = os.time()

        --帮派信息
        self:帮派信息("成员#G%s#W下线了", P.名称)
        return true
    end
end

function 帮派:权限信息(n)
    local t = {}
    for k, v in self:遍历成员() do
        if v.权限 > 1 then
            table.insert(t, v.nid)
        end
    end

    for _, nid in ipairs(t) do
        if __玩家[nid] then
            __玩家[nid].rpc:界面消息_帮派()
        end
    end
end

function 帮派:申请加入(P)
    if #self.申请列表 >= 100 then
        return "该帮派申请列表已经满了！"
    elseif self.申请列表[P.nid] then
        return "你已经申请加入,请耐心等待管理审核！"
    elseif self.成员数量 >= self.最大成员数量 then
        return "改帮派成员已满！"
    end
    self.申请列表[P.nid] = {
        nid = P.nid,
        等级 = P.等级,
        转生 = P.转生,
        名字 = P.名称,
        申请时间 = os.time(),
    }
    self:权限信息(1)
    --给管理们发信息
    return "你已经申请加入,请耐心等待管理审核！"
end

function 帮派:帮派响应成功(P)
    self.响应成功 = true
    for nid, v in pairs(self.响应列表) do
        if __玩家[nid] then
            self:成员添加(__玩家[nid], v.职务)
        else
            __存档.修改帮派(nid, self.名称)
            self.成员列表[nid] = v
            self.成员数量 = self.成员数量 + 1
        end
        self.响应列表[nid] = nil
    end
end

function 帮派:响应帮派(P)
    if self.响应 > 20 then
        return
    end
    self.响应 = self.响应 + 1
    self:添加响应(P, "帮众")
    if self.响应 >= 20 then
        self:帮派响应成功()
    end
    -- self:成员添加(P, "帮众")

    --  table.insert(self.响应列表, P.nid)
    return true
end

function 帮派:帮派信息(str, ...)
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.rpc:界面信息_聊天('#67 %s', str)
end

function 帮派:删除()
    __帮派[self.名称] = nil
end

return 帮派
