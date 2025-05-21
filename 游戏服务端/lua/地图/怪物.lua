local 地图怪物 = class('地图怪物')

function 地图怪物:初始化(map, t)
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

function 地图怪物:__index(k)
    local t = rawget(self, '_数据')
    if t then
        return t[k]
    end
end

function 地图怪物:生成对象() --屏幕
    return setmetatable(
        {
            是否可见 = true,
            状态 = {},
        },
        { __index = self }
    )
end

function 地图怪物:取简要数据()
    return {
        type = '明雷',
        nid = self.nid,
        名称 = self.名称,
        外形 = self.外形,
        称谓 = self.称谓,
        方向 = self.方向,
        x = self.x,
        y = self.y
    }
end

function 地图怪物:删除()
    if self._来源 then
        self._来源:删除怪物(self.nid)
    end
end

function 地图怪物:进入战斗(v)
    self.战斗中 = v
    return self.战斗中
end

function 地图怪物:是否战斗中()
    return self.战斗中
end

return 地图怪物
