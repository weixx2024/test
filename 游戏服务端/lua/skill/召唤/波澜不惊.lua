local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '波澜不惊',
    是否被动 = true,
}
-- 每回合开始，有15%几率摆脱混乱、遗忘状态。

local BUFF
function 法术:进入战斗(自己)
    local b = 自己:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

BUFF = {
    法术 = '波澜不惊',
    名称 = '波澜不惊',
}

法术.BUFF = BUFF

function BUFF:BUFF回合开始(自己)
    local 概率 = 15
    if math.random(100) <= 100 then
        自己.当前数据:喊话('波澜不惊#2')
        自己:删除BUFF('混乱')
        自己:删除BUFF('遗忘')
    end
end

function 法术:法术取描述()
    return '每回合开始，有15%几率摆脱混乱、遗忘状态。'
end

return 法术
