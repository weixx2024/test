local 任务 = {
    名称 = '枯荣丹',
    --图标 = 1,
    是否BUFF = true
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    if self.时间 <= os.time() then
        self:删除(玩家)
    end
end

function 任务:任务更新(sec, 玩家)
    --print(self.时间)
    if self.时间 <= sec then
        self:删除(玩家)
    end
end


function 任务:添加任务(玩家, 召唤)
    self.时间 = os.time() + 60 * 60
    self.对象id = 召唤.nid
    玩家:添加任务(self)
    return true
end

function 任务:添加时长(时间)
    self.时间 = self.时间 + 时间 * 60
    return true
end

function 任务:重置任务(玩家, 召唤)
    self.时间 = os.time() + 60 * 60
    self.对象id = 召唤.nid
    return true
end



function 任务:任务取详情(玩家)
     return '枯荣丹有效时间还剩: #G' .. tostring((self.时间 - os.time()) // 60)
end

return 任务
