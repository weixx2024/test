local 任务 = {
    名称 = '摄妖香',
    --图标 = 1,
    是否BUFF = true
}

function 任务:任务初始化(玩家, ...)
    self.时间 = os.time() + 60 * 60
end

function 任务:任务上线(玩家)
   -- self:删除()
end


function 任务:摄妖香()
    return true
end

function 任务:添加时间()
    self.时间 = self.时间  + 3600
end

function 任务:任务更新(玩家, sec)
    if self.时间 < os.time() then
        self:删除()
    end
end

function 任务:任务取详情(玩家)
    return '#Y剩余时间 #G' .. tostring((self.时间 - os.time()) // 60) .. "分钟"
end

return 任务
