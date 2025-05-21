local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '鼓音三叠',
    是否被动 = true,
}
-- 受到伤害时有几率由三个分身一起来承受伤害，如果触发此技能则自己本身只承受伤害的1/3，每回合最多触发一次。

local BUFF
function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

BUFF = {
    法术 = '鼓音三叠',
    名称 = '鼓音三叠',
}

法术.BUFF = BUFF

function BUFF:BUFF回合开始()
    self.触发 = false
end

function BUFF:BUFF气血伤害(攻击方, 挨打方)
    local 伤害 = 攻击方.伤害
    local 概率 = 取召唤技能数值(挨打方.转生, 挨打方.等级, 挨打方.亲密, 0.5, 1, 20)
    概率 = 100
    if math.random(100) <= 概率 and not self.触发 then
        self.触发 = true
        挨打方:当前喊话('鼓音三叠#2', 8)
        伤害 = math.floor(攻击方.伤害 * 0.33)
    end

    return 伤害
end

return 法术
