local 事件 = {}

function 事件:定时(ms, fun, ...)
    if not self._定时表 then
        self._定时表 = {}
    end
    self._定时表[fun] = __世界:定时(
        ms * 1000,
        function(...)
            if self._停止所有 then
                return
            end
            local r = ggexpcall(fun, self, ...)
            if type(r) == 'number' then
                r = r * 1000
            end
            return r
        end,
        ...
    )
end

function 事件:删除定时(fun)
    if not fun then
        self._停止所有 = true
    end
end

function 事件:生成地图(id, 类型)
    if __地图[id] then
        local map = __地图[id]:生成副本()
        if 类型 then
            map.类型 = 类型
        end
        __副本地图[map.id] = map
        return map and map.接口
    end
end

function 事件:取地图(id)
    local map = __地图[id]
    return map and map.接口
end

function 事件:删除NPC(mid, nid)
    local map = self:取地图(mid)
    if map then
        map:删除NPC(nid)
    end
end

function 事件:取随机地图(t)
    if type(t) ~= 'table' then
        return
    end
    local map
    local n = 0
    repeat
        map = __地图[t[math.random(#t)]]
        n = n + 1
    until map or n > 100
    return map and map.接口
end

function 事件:发送世界(...) --69
    __世界:发送世界(...)
end

function 事件:发送系统(...) --71
    __世界:发送系统(...)
end

function 事件:发送信息(...) --114
    __世界:发送信息(...)
end

return 事件
