local 任务 = {
    名称 = '大闹天宫',
    类型 = '限时活动'
}

function 任务:任务初始化(玩家, ...)

end

function 任务:任务上线(玩家)

end

function 任务:添加积分(n)
    self.积分 = self.积分 + n
end

function 任务:任务更新(sec, 玩家)

end

local _阵营 = { "花果山", "天庭" }
local _敌营 = { "天庭", "花果山" }
function 任务:任务取详情(玩家)
    return string.format("#Y任务目的:#r#W加入#G%s#W一方进攻#G%s#r#r#Y任务状态：#r#W战场积分：#G%s#r#r#Y任务提示:#r#W1:可前往战场前线作战，攻击敌方箭塔，#r2:可攻击敌方指挥官夺取军旗,降低敌方士气#r3:有信心的勇士们可攻击二郎神获得丰厚的奖励#r4:活动时间内，有一方指挥官血量为0则活动结束，首领死亡的一方失败，获胜方额外获得20000积分奖励#r"
        ,
        _阵营[self.阵营], _敌营[self.阵营], self.积分)
end

return 任务
