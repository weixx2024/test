local 任务 = {
    名称 = '引导_轮回转世',
    别名 = '轮回转世',
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

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_轮回转世')
    if r then
        local 银子 = 0
        local 经验 = 5000
        玩家:添加参战召唤兽经验(经验 * 1.5)
        玩家:添加师贡(银子)
        玩家:添加经验(经验)
        self:删除()
    end
end
local _详情 = '你已经达到转生条件了，去找#G孟婆#W转生吧！'
function 任务:任务取详情(玩家)
    return _详情
end

return 任务
