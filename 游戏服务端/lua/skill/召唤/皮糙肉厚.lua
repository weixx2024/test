local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '皮糙肉厚',
    是否被动 = true,
}
-- 每次受到攻击的最大伤害不得超过自身血上限的49%。(根骨需求700点)

local BUFF
function 法术:进入战斗(自己)
    if 自己.根骨 < 700 then
        return
    end
    local b = 自己:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

function 法术:召唤进入战斗(攻击方,数据,目标,闪现)
    if 目标.根骨 < 700 then
        return
    end
    local b = 目标:进入添加BUFF(BUFF)
    b.回合 = 150
end


BUFF = {
    法术 = '皮糙肉厚',
    名称 = '皮糙肉厚',
}
法术.BUFF = BUFF

function BUFF:BUFF气血伤害(攻击方, 挨打方)
    local 伤害 = 攻击方.伤害
    local 最大伤害 = math.ceil(挨打方.最大气血 * 0.49)
    if 伤害 > 最大伤害 then
        挨打方.当前数据:喊话('皮糙肉厚#2')
        伤害 = 最大伤害
    end
    return 伤害
end

function 法术:法术取描述()
    return '每次受到攻击的最大伤害不得超过自身血上限的49%。(根骨需求700点)。'
end

return 法术
