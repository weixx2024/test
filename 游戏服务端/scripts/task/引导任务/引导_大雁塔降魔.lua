local 任务 = {
    名称 = '引导_大雁塔降魔',
    别名 = '大雁塔降魔引导',
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
    if self.进度 >= 7 then
        self:完成(玩家)
    end
end
function 任务:完成(玩家)
    local r = 玩家:取任务('引导_大雁塔降魔')
    if r then
        local 银子 = 0
        local 经验 = 5000
        玩家:添加参战召唤兽经验(经验 * 1.5)
        玩家:添加师贡(银子)
        玩家:添加经验(经验)
        self:删除()
    end
end
local _详情 = '去找#G慈恩寺方丈#W谈谈。#r完成慈恩寺方丈交给你的大雁塔降魔任务[大雁塔降魔 %s/7次]#r#Y任务提醒：#R该任务有一定难度，请组队带上小伙伴共同完成。'
function 任务:任务取详情(玩家)
    return _详情:format(self.进度)
end

return 任务
