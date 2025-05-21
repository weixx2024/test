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

local 地图物品 = class('地图物品')

function 地图物品:初始化(map, t)
    for k, v in pairs(t) do
        self[k] = v
    end
    self._来源 = map
    self._数据 = t
    if t.X then
        self.X = t.X
        self.Y = t.Y
        self.x = math.floor(t.X * 20)
        self.y = math.floor((map.高度 - t.Y) * 20)
    end
    if not self.nid then
        self.nid = __生成ID()
    end
end

function 地图物品:__index(k)
    local t = rawget(self, '_数据')
    if t then
        return t[k]
    end
end

function 地图物品:触发(玩家)
    if self.脚本 then
        local fun = _get(self.脚本, '触发')
        if type(fun) == 'function' then
            local r = ggexpcall(fun, self, 玩家)
            return r
        end
    end
end

function 地图物品:删除()
    if self._来源 then
        self._来源:删除物品(self.nid)
    end
end

function 地图物品:取简要数据()
    return {
        type = 'good',
        nid = self.nid,
        名称 = self.名称,
        外形 = self.外形,
        x = self.x,
        y = self.y
    }
end

return 地图物品
