local 任务 = {
    名称 = '引导_师门任务',
    别名 = '师门任务引导',
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

function 任务:学习技能(玩家)
    self.进度 = self.进度 + 1
    if self.进度 >= 12 then
        self:完成(玩家)
    end
end

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_师门任务')
    if r then
        local 银子 = 0
        local 经验 = 5000
        玩家:添加任务经验(经验, "引导_师门任务")
        玩家:添加师贡(银子)
        self:删除()
    end
end

local _详情 = '#Y任务目的:#r#W去对应师门处学习2阶至5阶法术[学习师门法术%s/12次]'
function 任务:任务取详情(玩家)
    return _详情:format(self.进度)
end

return 任务
