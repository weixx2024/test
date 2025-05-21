local 任务 = {
    名称 = '神行符',
    是否BUFF = true,
    图标 = 12531,
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    if self.时间 <= os.time() then
        玩家:地图对象开关神行符(玩家.nid, false)
        self:删除()
    end
end

function 任务:任务更新(sec, 玩家)
    if self.时间 <= sec then
        玩家:地图对象开关神行符(玩家.nid, false)
        self:删除()
    end
end

function 任务:添加任务(玩家)
    local r = 玩家:取任务("神行符")
    if r then
        玩家:地图对象开关神行符(玩家.nid, true)
        r:添加时长(1)
        return
    end
    self.时间 = os.time() + 10 * 60
    玩家:地图对象开关神行符(玩家.nid, true)
    玩家:添加任务(self)
    return true
end

function 任务:添加时长(n)
    self.时间 = self.时间 + n * 10 * 60
end

function 任务:任务取详情(玩家)
    return '#Y剩余时间 #G' .. tostring((self.时间 - os.time()) // 60) .. "分钟"
end

return 任务
