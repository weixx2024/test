local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '妙转乾坤',
    是否被动 = true,
}
-- 100%几率将自己受到的50%气血伤害转化为法力伤害。
-- 如果召唤兽法力不足，妙转乾坤无法起到作用，将按原伤害扣血。

local BUFF
function 法术:进入战斗(自己)
    local b = 自己:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

BUFF = {
    法术 = '妙转乾坤',
    名称 = '妙转乾坤',
}
法术.BUFF = BUFF

function BUFF:BUFF气血伤害(攻击方, 挨打方)
    local 伤害 = 攻击方.伤害
    local 减伤 = math.floor(攻击方.伤害 * 0.5)

    if 挨打方.魔法 >= 减伤 then
        挨打方:可视减少魔法(减伤)
        伤害 = 减伤
    end

    return 伤害
end

return 法术
