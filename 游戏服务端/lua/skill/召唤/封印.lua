local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '封印',
    id = 304,
}
local BUFF

function 法术:物理攻击(攻击方, 挨打方)
    if 挨打方 then
        local 几率 = self:取几率(攻击方, 挨打方)  
        if 几率 > math.random(100) then
            local b = 挨打方:添加BUFF(BUFF)
            if b then
                b.回合 = 1
            end
        end
        return true,"禁止"
    end
end

function 法术:法术取描述(P)
    local str = self:取几率(P).."%"
    return string.format("上至碧落仙佛，下至黄泉妖魔，被自己攻击的敌人都会受到封印的诅咒。#r#W【技能介绍】#r#G物理攻击时有%s几率释放单体封印，持续1回合"
        , str)
end

function 法术:取几率(攻击方, 挨打方)
    local 亲密度 = 攻击方.亲密 or 0
    local 几率 = 10 + math.floor(亲密度 ^ 0.17)
    return 几率
end

BUFF = {
    法术 = '召唤封印',
    名称 = '封印',
    id = 401
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('混乱')
        目标:删除BUFF('昏睡')
        目标:删除BUFF('中毒')
        目标:删除BUFF('遗忘')
    end
end

function BUFF:BUFF指令开始(目标) --昏睡
    if 目标.指令 == '道具' or 目标.指令 == '召唤' or 目标.指令 == '招还' then
        return true
    end
    return false
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
