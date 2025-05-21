local 地图跳转 = class('地图跳转')

function 地图跳转:初始化(map, t)
    for k, v in pairs(t) do
        self[k] = v
    end
    if t.X then
        self.x = math.floor(t.X * 20)
        self.y = math.floor((map.高度 - t.Y) * 20)
    end
    if t.tX and __地图[t.tid] then
        local map = __地图[t.tid]
        self.tx = math.floor(t.tX * 20)
        self.ty = math.floor((map.高度 - t.tY) * 20)
    end
    if not self.nid then
        self.nid = __生成ID()
    end
end

function 地图跳转:取目标()
    return __地图[self.tid], self.tx, self.ty
end

function 地图跳转:取简要数据()
    return {
        type = 'jump',
        nid = self.nid,
        名称 = self.名称,
        外形 = self.外形,
        x = self.x,
        y = self.y
    }
end

return 地图跳转
