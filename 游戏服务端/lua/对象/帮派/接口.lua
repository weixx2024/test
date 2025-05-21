local 接口 = {
    成员数量 = true,
    名称 = true,
    nid = true,
    响应成功 = true,
    -- 地图 = true,
    -- PK = true
}


function 接口:取成员(nid)
    return self:取成员(nid)
end

function 接口:取现状信息()
    return self:取现状信息()
end

function 接口:任命成员(nid, p, v)
    return self:任命成员(nid, p, v)
end

function 接口:逐出成员(nid, p)
    return self:逐出成员(nid, p)
end

function 接口:删除申请人(nid)
    return self:删除申请人(nid)
end

function 接口:是否满员()
    return self:是否满员()
end

function 接口:发送信息(...)
    self.rpc:界面信息_聊天(...)
end

function 接口:解散帮派()
    return self:解散帮派()
end

function 接口:打开帮派管理(nid)
    return self:打开帮派管理(nid)
end

function 接口:同步成员成就(nid, n)
    return self:同步成员成就(nid, n)
end

function 接口:成员上线(P)
    return self:成员上线(P)
end

function 接口:成员下线(P)
    return self:成员下线(P)
end

function 接口:添加建设度(n)
    return self:添加建设度(n)
end

function 接口:进入地图(P)
    return self:进入地图(P)
end

function 接口:取成员帮派贡献(nid)
    return self:取成员帮派贡献(nid)
end

function 接口:取成员帮派成就(nid)
    return self:取成员帮派成就(nid)
end

function 接口:删除成员(nid)
    if self.成员列表[nid] then
        self.成员数量 = self.成员数量 - 1
        self.成员列表[nid] = nil
    end
end

function 接口:进入帮战地图(P, t)
    if not __帮战:是否已报名(self.名称) then
        return "你的帮派没有报名"
    end
    if self.帮战地图 then
        for i, v in ipairs(t) do
            self.成员列表[v].帮战进场 = true
        end
        P:移动_切换地图(self.帮战地图, 1524, 1313)
    end
end

function 接口:取地图()
    return self.地图 and self.地图.接口
end

function 接口:帮战是否失败()
    local n = 0
    if self.帮战地图 then
        n = self.帮战地图:取同帮玩家数量(self.名称)
    end
    if n == 0 then
        return self.敌对帮派
    end
end

if not package.loaded.帮派接口_private then
    package.loaded.帮派接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('帮派接口_private')

local 帮派接口 = class('帮派接口')

function 帮派接口:初始化(P)
    _pri[self] = P
end

function 帮派接口:__index(k)
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

return 帮派接口
