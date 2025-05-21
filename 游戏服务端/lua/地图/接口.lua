--可以访问的属性
local 接口 = {
    id = true,
    名称 = true,
    PK = true,
    飞行 = true,
    是否副本 = true,
    是否帮派 = true,
    是否帮战 = true,
    地图等级 = true,
    是否大闹 = true,
    rid = true,
}

--可以访问的方法
function 接口:遍历玩家()
    return next, self.玩家
end

function 接口:遍历NPC()
    return next, self.NPC
end

function 接口:发送系统(...) --71
    __世界:发送系统(...)
end


function 接口:添加怪物(t)
    local r = self:添加怪物(t)
    return r and r.nid
end

function 接口:清空怪物()
    self:清空怪物()
end

function 接口:删除怪物(nid)
    return self:删除怪物(nid)
end

function 接口:取NPC(id)
    return self.NPC[id]
end

function 接口:添加NPC(t)
    local r = self:添加NPC(t)
    return r and r.nid
end

function 接口:删除NPC(nid)
    return self:删除NPC(nid)
end

function 接口:添加物品(t)
    local r = self:添加物品(t)
    return r and r.nid
end

function 接口:删除物品(t)
    local r = self:删除物品(t)
    return r and r.nid
end

function 接口:取随机坐标(...)
    return self:随机坐标(...)
end

function 接口:清空玩家(id, x, y)
    return self:清空玩家(id, x, y)
end

local _可用 = {
    普通 = true,
    商业 = true,
}

function 接口:取随机NPC(...)
    local list = {}
    for k, v in self:遍历固定NPC() do
        if _可用[v.分类] and v.名称 ~= "超级巫医" then
            table.insert(list, { v.名称, v.nid, v.X, v.Y })
        end
    end
    return list[math.random(#list)]
end

-- function 接口:取同帮玩家数量(name)
--     local n = 0
--     for k, v in self:遍历玩家() do
--         if v.帮派 == name then
--             n = n + 1
--         end
--     end
--     return n
-- end

if not package.loaded.角色接口_private then
    package.loaded.角色接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('角色接口_private')
local 地图接口 = class('地图接口')

function 地图接口:初始化(P)
    _pri[self] = P
end

function 地图接口:__index(k)
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

function 地图接口:__pairs(k)
    return 接口
end

return 地图接口
