-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2023-08-23 23:26:33
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '水中探月',
    是否单独物理法术 = true,
    是否被动 = true,
}

local BUFF
function 法术:水中探月计算(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) < self:取几率(攻击方)  then
            return true
        end
    end
end

function 法术:水中探月附加(攻击方, 挨打方)
    local dst = 挨打方:取附近目标(挨打方.位置)
    挨打方:被物理攻击(攻击方,挨打方,1)
    for i,v in ipairs(dst) do
        攻击方 = 攻击方:物理_生成对象('物理', v)
        攻击方.伤害 = self:取伤害(攻击方, 挨打方)
        攻击方.躲避 = false
        v:被物理攻击(攻击方,v)
    end
end


function 法术:取伤害(攻击方, 挨打方)
    local ndcd = math.floor(296.1572 + 0.00023 * math.pow(攻击方.最大魔法, 1.57));
    return math.floor(ndcd)
end

function 法术:取几率(召唤)
    local qm = 召唤.亲密
    return math.floor(35 + SkillXS(qm, 0.43))
end

function 法术:法术取描述(召唤)
    return string.format("触发水中探月技能时，倒影中的少年将舞起长剑，对目标附近所有敌人进行攻击。")
end

return 法术
