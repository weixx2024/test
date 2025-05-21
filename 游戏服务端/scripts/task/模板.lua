local 任务 = {
    名称 = '模板',
    类型 = '测试任务'
}

function 任务:任务初始化(玩家, ...)
    self.进度 = 1
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(玩家, sec)
end

function 任务:任务取详情(玩家)
    return '任务描述 #G' .. tostring(self.进度)
end

function 任务:任务NPC对话(玩家, NPC)
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:升级事件(玩家)
end

function 任务:切换地图前事件(玩家, 地图)
    if 玩家.等级 < 10 then
        return false
    end
end

return 任务
