local 任务 = {
    名称 = '强法符文',
    是否BUFF = true
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    if self.时间 <= os.time() then
        self:删除()
        玩家:刷新属性()
    end
end

function 任务:任务更新(sec, 玩家)
    if self.时间 <= sec then
        self:删除()
        玩家:刷新属性()
    end
end

function 任务:添加任务(玩家, t)
    local r = 玩家:取任务("强法符文")
    if r then
        if t.id == r.符文id then
            r:添加时长(1)
            return
        else
            r:删除()
        end
    end
    self.时间 = os.time() + 60 * 60
    self.图标 = t.id
    self.符文id = t.id
    self.符文名称 = t.名称
    self.属性 = t.属性
    self.数值 = t.数值
    玩家:添加任务(self)
    玩家:刷新属性()
    return true
end

function 任务:添加时长(n)
    self.时间 = self.时间 + n * 60 * 60
end

function 任务:强法符文计算(玩家)
    if type(self.属性) == 'string' then
        玩家.抗性[self.属性] = 玩家.抗性[self.属性] + self.数值
    else
        for k, v in pairs(self.属性) do
            玩家.抗性[v] = 玩家.抗性[v] + self.数值
        end
    end
end

function 任务:任务取详情(玩家)
    return '强法符文: ' .. self.符文名称 .. '效果还可持续#G' .. tostring((self.时间 - os.time()) // 60) .. '#W分钟'
end

return 任务
