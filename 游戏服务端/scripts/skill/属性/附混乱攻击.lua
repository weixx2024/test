local 法术 = {
    类别 = '属性',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '附混乱攻击',
    id = 304,
    是否物理法术 = true,
}

local BUFF

function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        挨打方:被使用法术(攻击方, self)
        local 几率 = 100--self:法术取几率(攻击方, 挨打方)
        if math.random(100) < 几率 then
            local b = 挨打方:添加BUFF(BUFF)
            if b then
                b.回合 = 3
                b.挣脱率 = 100 - 50
            end
        end
        return true
    end
end

function 法术:是否触发(攻击方, 挨打方)
    if math.random(100) <= 攻击方.附混乱攻击 then
        return true
    end
end

function 法术:法术取几率(攻击方, 挨打方)
    local 几率 = 86
    几率 = 几率 + 3.6 * 1 ^ 0.3
    几率 = (几率 + 攻击方.忽视抗混 - 挨打方.抗混乱) * (1 + 攻击方.加强混乱 *
        0.01)
    几率 = 几率 * math.random(70, 100) * 0.01
    return 几率
end

BUFF = {
    法术 = '借刀杀人',
    名称 = '混乱',
    id = 301
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('昏睡')
        -- 目标:删除BUFF('中毒')
        目标:删除BUFF('遗忘')
    end
end

function BUFF:BUFF回合开始() --挣脱
    if math.random(100) < self.挣脱率 then
        self:删除()
    end
end

function BUFF:BUFF指令开始(目标) --混乱
    local r
    if math.random(100) > 50 then
        r = 目标:随机我方存活目标()
    else
        r = 目标:随机敌方存活目标()
    end
    目标:置指令('物理', r)
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function BUFF:BUFF队友伤害(来源)
    return true
end

return 法术
