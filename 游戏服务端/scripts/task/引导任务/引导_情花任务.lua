--完成
local 任务 = {
    名称 = '引导_情花任务',
    别名 = '情花活动引导',
    类型 = '引导任务',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

function 任务:添加进度(玩家)
    self.进度 = self.进度 + 1
    if self.进度 >= 4 then
        self:完成(玩家)
    end
end

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_情花任务')
    if r then
        local 银子 = 0
        local 经验 = 5000
        玩家:添加任务经验(经验, '情花引导')
        玩家:添加师贡(银子, '情花引导')
        self:删除()
    end
end

local _详情 = '去问候下#G情花仙子#W近来可好。[情花活动引导]#r完成情花任务[种植情花%s/4次]#r#Y任务提醒：#R该任务需有异性队员2人组队完成。'
function 任务:任务取详情(玩家)
    return _详情:format(self.进度)
end

return 任务
