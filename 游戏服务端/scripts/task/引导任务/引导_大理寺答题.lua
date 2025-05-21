local 任务 = {
    名称 = '引导_大理寺答题',
    别名 = '大理寺答题引导',
    类型 = '引导任务',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    if not self.进度 then
        self.进度 = 1
    end
end

function 任务:添加进度(玩家)
    if not self.进度 then
        self.进度 = 1
    end
    self.进度 = self.进度 + 1
    if self.进度 >= 15 then
        self:完成(玩家)
    end
end

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_大理寺答题')
    if r then
        local 银子 = 0
        local 经验 = 5000
        玩家:添加参战召唤兽经验(经验 * 1.5)
        玩家:添加师贡(银子)
        玩家:添加经验(经验)
        self:删除()
    end
end

local _详情 = '去找#G大理寺官员#W聊聊。[大理寺答题引导]#r接受大理寺官员的考验[大理寺答题%s/15次]'
function 任务:任务取详情(玩家)
    if not self.进度 then
        self.进度 = 1
    end
    return _详情:format(self.进度)
end

return 任务
