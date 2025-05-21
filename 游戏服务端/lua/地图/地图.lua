local function _uncell(data)
    if data then
        local mw, mh, pos = string.unpack('<I4I4', data)
        local CELL = {}
        for h = 1, mh do
            CELL[h] = {}
            for w = 1, mw do
                if h > 2 and h < mh - 2 and w > 2 and w < mw - 2 then
                    if string.unpack('<B', data, pos) == 0 then
                        CELL[h][w] = true
                    end
                end
                pos = pos + 1
            end
        end
        return CELL
    end
end

local function _get(s, name)
    if not s then
        return
    end
    local 脚本 = __脚本[s] or __脚本['npc/默认.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end


local 地图 = class('地图类')

function 地图:初始化(data)
    for _, k in ipairs { 'id', '文件', '名称', '宽度', '高度', 'PK', '飞行', '可遇怪', '是否副本', 'sub', '脚本' } do
        self[k] = data[k]
    end
    self.地图等级 = data.min
    self.地图最高等级 = data.max or data.min
    self.对象 = setmetatable({}, { __mode = 'v' })
    self.玩家 = {}
    self.召唤 = {}
    self.物品 = {}
    self.队伍 = {}
    self.实际宽度 = data.实际宽度 or self.宽度
    self.实际高度 = data.实际高度 or self.高度
    self.w = self.宽度
    self.h = self.高度
    self.宽度 = self.实际宽度 // 20
    self.高度 = self.实际高度 // 20

    self.CELL = data.障碍 and _uncell(data.障碍) or data.CELL

    self.NPC = {} --所有
    self.固定NPC = {} --固定
    self.动态NPC = {} --动态
    self.水陆 = {}
    self.跳转 = {}
    self.怪物 = {}
    self.接口 = require('地图/接口')(self)
    if data.是否大闹 then
        self.是否大闹 = true
    end
end

local 副本编号 = {}
function 地图:生成副本()
    if not 副本编号[self.id] then
        副本编号[self.id] = 0
    end
    副本编号[self.id] = 副本编号[self.id] + 1
    if 副本编号[self.id] > 30000 then
        副本编号[self.id] = 1
    end
    local map = 地图(self)
    map.id = (副本编号[self.id] << 17) | self.id
    map.是否副本 = true
    map.rid = self.id
    return map
end

function 地图:加载NPC(list)
    for _, v in pairs(self.固定NPC) do
        self:删除NPC(v)
    end
    for _, v in ipairs(list) do
        if v.mid == self.id then
            v.X = v.x
            v.Y = v.y
            self:添加固定NPC(v)
        end
    end
    for _, v in pairs(self.水陆) do
        self:删除NPC(v)
    end
    for i, v in ipairs(__水陆排行帮) do
        if v.mid == self.id then
            v.X = v.x
            v.Y = v.y
            self:添加水陆NPC(v)
        end
    end
end

function 地图:加载水陆NPC()
    for _, v in pairs(self.水陆) do
        self:删除NPC(v)
    end
    for i, v in ipairs(__水陆排行帮) do
        if v.mid == self.id then
            v.X = v.x
            v.Y = v.y
            self:添加水陆NPC(v)
        end
    end
end

function 地图:加载跳转(list)
    for _, v in pairs(self.跳转) do
        self:删除跳转(v)
    end

    for _, v in ipairs(list) do
        if v.mid == self.id then
            local m = __地图[v.tid]
            if m then
                --v.名称 = m.名称
                v.X = v.x
                v.Y = v.y
                v.tX = v.tx
                v.tY = v.ty
                -- v.x = math.floor(v.x * 20)
                -- v.y = math.floor((self.高度 - v.y) * 20)
                -- v.tx = math.floor(v.tx * 20)
                -- v.ty = math.floor((m.高度 - v.ty) * 20)
                self:添加跳转(v)
            else
                print('传送地图错误 %s>%s', v.mid, v.tid)
            end
        end
    end
end

function 地图:更新(sec)
    for k, v in pairs(self.动态NPC) do
        v:更新(sec)
        if v.时间 then
            if v.时间 <= sec then
                v:删除()
            end
        end
    end
    local fun = _get(self.脚本, '处理事件')
    if type(fun) == 'function' then
        ggexpcall(fun, self, self)
    end
    --怪物存在时间删除
end


function 地图:检查点(x, y)
    if type(x) == 'number' and type(y) == 'number' then
        return x > 0 and y > 0 and x < self.实际宽度 and y < self.实际高度
    end
end

function 地图:遍历对象()
    return next, self.对象
end

function 地图:取对象(nid)
    return self.对象[nid]
end

--=============================================================
function 地图:添加玩家(obj)
    self.对象[obj.nid] = obj
    self.玩家[obj.nid] = obj
end

function 地图:删除玩家(obj)
    if self.玩家[obj.nid] then
        self.玩家[obj.nid] = nil
        self.对象[obj.nid] = nil
        return true
    end
end

function 地图:取玩家(nid)
    return self.玩家[nid]
end

function 地图:遍历玩家()
    return next, self.玩家
end

function 地图:清空玩家(id, x, y)
    for k, v in self:遍历玩家() do
        v.接口:切换地图(id, x, y)
    end
end

function 地图:取同帮玩家数量(name)
    local n = 0
    for k, v in self:遍历玩家() do
        if v.帮派 == name then
            n = n + 1
        end
    end
    return n
end

--=============================================================
function 地图:添加召唤(obj)
    self.对象[obj.nid] = obj
    self.召唤[obj.nid] = obj
end

function 地图:删除召唤(obj)
    if obj and self.召唤[obj.nid] then
        self.召唤[obj.nid] = nil
        self.对象[obj.nid] = nil
        return true
    end
end

地图.添加宠物 = 地图.添加召唤
地图.删除宠物 = 地图.删除召唤

--=============================================================
function 地图:添加怪物(t)
    local obj = require('地图/怪物')(self, t)
    self.对象[obj.nid] = obj
    self.怪物[obj.nid] = obj
    if t.时间 then
        self.动态NPC[obj.nid] = obj
    end
    return obj
end

function 地图:删除怪物(obj)
    local nid = ggetype(obj) == '地图怪物' and obj.nid or obj
    if self.怪物[nid] then
        self.怪物[nid] = nil
        self.动态NPC[nid] = nil
        self.对象[nid] = nil
        return true
    end
end

function 地图:清空怪物()
    for k, v in self:遍历怪物() do
        self:删除怪物(v)
    end
end

function 地图:取怪物(nid)
    return self.怪物[nid]
end

function 地图:遍历怪物()
    return next, self.怪物
end

--=============================================================
function 地图:添加固定NPC(t)
    local obj = require('地图/NPC')(self, t)
    self.对象[obj.nid] = obj
    self.NPC[obj.nid] = obj
    self.固定NPC[obj.nid] = obj
    return obj
end

function 地图:添加水陆NPC(t)
    local obj = require('地图/NPC')(self, t)
    self.对象[obj.nid] = obj
    -- self.动态NPC[obj.nid] = obj
    self.NPC[obj.nid] = obj
    self.水陆[obj.nid] = obj
    return obj
end

function 地图:添加NPC(t)
    t.动态 = true
    local obj = require('地图/NPC')(self, t)
    self.对象[obj.nid] = obj
    self.NPC[obj.nid] = obj
    self.动态NPC[obj.nid] = obj
    return obj
end

function 地图:删除NPC(obj)
    local nid = ggetype(obj) == '地图NPC' and obj.nid or obj
    if self.NPC[nid] then
        self.NPC[nid] = nil
        self.固定NPC[nid] = nil
        self.动态NPC[nid] = nil
        self.对象[nid] = nil
        self.水陆[nid] = nil
        return true
    end
end

function 地图:取NPC(id)
    return self.NPC[id]
end

function 地图:遍历NPC()
    return next, self.NPC
end

function 地图:遍历固定NPC()
    return next, self.固定NPC
end

--=============================================================
function 地图:添加跳转(t)
    local r = require('地图/跳转')(self, t)
    self.跳转[r.nid] = r
    self.对象[r.nid] = r
    return r
end

function 地图:删除跳转(obj)
    local nid = type(obj) == 'table' and obj.nid or obj
    if self.跳转[nid] then
        self.跳转[nid] = nil
        self.对象[nid] = nil
        return true
    end
end

function 地图:取跳转(nid)
    return self.跳转[nid]
end

function 地图:遍历跳转()
    return next, self.跳转
end

--=============================================================
function 地图:添加物品(t)
    local r = require('地图/物品')(self, t)
    self.物品[r.nid] = r
    self.对象[r.nid] = r
    self.动态NPC[r.nid] = r
    return r
end

function 地图:删除物品(obj)
    local nid = type(obj) == 'table' and obj.nid or obj
    if self.物品[nid] then
        self.物品[nid] = nil
        self.对象[nid] = nil
        self.动态NPC[nid] = nil
        return true
    end
end

--=============================================================
-- function 地图:遍历队伍()
--     return next, self.队伍
-- end

function 地图:遍历队伍()
    local k, v
    return function(list)
        k, v = next(list, k)
        if v then
            return k, v.接口
        end
    end, self.队伍 or { self }
end

function 地图:随机坐标(x, y, 正, 负)
    local n = 0
    if not x or not y then
        repeat
            x = math.random(self.宽度)
            y = math.random(self.高度)
            n = n + 1
        until (self.CELL[y] and self.CELL[y][x]) or n > 100
        if n > 100 then
            warn('地图:随机坐标')
            return
        end
    else
        local bx, by, _x, _y = x, y, nil, nil
        y = self.高度 - y
        repeat
            _x = x + math.random(正, 负)
            _y = y + math.random(正, 负)
            n = n + 1
        until (self.CELL[_y] and self.CELL[_y][_x]) or n > 100
        if n > 100 then
            warn('地图:随机坐标2')
            return bx, self.高度 - by
        else
            x, y = _x, _y
        end
    end
    return x, self.高度 - y
end

function 地图:随机游戏坐标()
    local _, _, x, y = self:随机坐标()
    return x, y
end

-- function 地图:随机NPC()
--     if #self.NPC固定>0 then
--         local npc
--         repeat
--             npc = self.NPC固定[math.random(#self.NPC固定)]
--         until npc and npc.类型==0
--         return npc
--     end
-- end

return 地图
