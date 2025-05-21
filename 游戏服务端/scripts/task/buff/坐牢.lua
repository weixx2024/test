local 任务 = {
    名称 = '坐牢',
    类型 = '其它',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
    self.时间 = os.time() + 172800
end

function 任务:任务更新(sec, 玩家)
    if self.时间 < os.time() then
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if self.时间 < os.time() then
        self:删除()
    end
end

function 任务:使用特赦令(玩家)
    self:删除()
    玩家:切换地图(1001, 332, 24)
end

function 任务:任务取详情(玩家)
    return '#Y剩余时间 #G' .. tostring((self.时间 - os.time()) // 60) .. "分钟"
end

function 任务:切换地图前事件(玩家, 地图)
    return false
end

return 任务
