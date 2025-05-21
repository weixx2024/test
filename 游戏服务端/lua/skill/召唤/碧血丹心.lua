local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '碧血丹心',
    是否被动 = true,
}
-- 15%的几率反震自身受到的伤害的15%(被动)

local BUFF
function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

BUFF = {
    法术 = '碧血丹心',
    名称 = '碧血丹心',
}

法术.BUFF = BUFF

function BUFF:BUFF气血伤害(攻击方, 挨打方)
    local 伤害 = 攻击方.伤害
    local 反震 = math.floor(攻击方.伤害 * 0.15)

    if math.random(100) <= 15 then
        挨打方:当前喊话('碧血丹心#2', 8)
        攻击方:减少气血(反震)
    end

    return 伤害
end

return 法术
