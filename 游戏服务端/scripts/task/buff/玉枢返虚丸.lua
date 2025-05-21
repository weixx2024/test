local 任务 = {
    名称 = '玉枢返虚丸',
    --图标 = 1,
    是否BUFF = true
}

function 任务:任务初始化(玩家, ...)

end

function 任务:任务上线(玩家)
    -- self:删除()
end

function 任务:添加任务(玩家)
    self.时间 = os.time() + 3600 * 72
    self.HP = 10000000
    self.MP = 10000000
    玩家:添加任务(self)
    return true
end

function 任务:添加时间()
    self.时间 = os.time() + 3600 * 72
    self.HP = 10000000
    self.MP = 10000000
end

function 任务:任务更新(sec, 玩家)
    if self.时间 < sec or (self.HP <= 0 and self.MP <= 0) then
        self:删除()
    end
end

function 任务:减少HP(n)
    self.HP = self.HP - n
    if self.HP < 0 then
        self.HP = 0
    end
end

function 任务:减少MP(n)
    self.MP = self.MP - n
    if self.MP < 0 then
        self.MP = 0
    end
end

function 任务:恢复血法(对象)
    if self.HP > 0 then
        local xhp = 对象.最大气血 - 对象.气血
        if self.HP < xhp then
            xhp = self.HP
        end
        self.HP = self.HP - xhp
        对象:增减气血(xhp, true)
    end
    if self.MP > 0 then
        local xMP = 对象.最大魔法 - 对象.魔法
        if self.MP < xMP then
            xMP = self.MP
        end
        self.MP = self.MP - xMP
        对象:增减魔法(xMP, true)
    end

    return true
end

function 任务:任务取详情(玩家)
    return '#Y剩余时间 #G' .. tostring((self.时间 - os.time()) // 60) ..
        "分钟#r#Y剩余HP#G" .. self.HP .. "#r#Y剩余MP#G" .. self.MP
end

return 任务
