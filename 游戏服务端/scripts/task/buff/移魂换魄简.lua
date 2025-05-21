local 任务 = {
    名称 = '移魂换魄简',
    是否隐藏 = true
    --图标 = 1,
    --是否BUFF = true
}

function 任务:任务初始化(玩家, ...)
    self.时间 = os.time() + 30 * 60
    -- 玩家:刷新外形()
end

function 任务:任务上线(玩家)
    if self.时间 <= os.time() then
        self:清除变身(玩家)
    end
end

function 任务:添加任务(玩家)
    local r = 玩家:取任务("变身卡")
    if r then
        r:清除变身(玩家)
    end
    self.时间 = os.time() + 30 * 60
    self.原形 = 玩家.外形
    self.外形 = 2064
    玩家:添加任务(self)
    玩家:刷新外形()
    return true
end

function 任务:清除变身(玩家)
    self:删除()
    玩家:刷新外形()
end

function 任务:任务更新(sec, 玩家)
    if self.时间 <= sec then
        self:清除变身(玩家)
    end
end

function 任务:任务取详情(玩家)
    return '剩余变身时间: #G' .. tostring((self.时间 - os.time()) / 60)
end

return 任务
