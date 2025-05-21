-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-09-28 18:34:50
-- @Last Modified time  : 2024-09-28 22:59:08

local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '分花拂柳',
    是否被动 = true,
	id = 2543,
}
function 法术:物理攻击追加(攻击方,挨打方)
    if 挨打方.是否死亡 and self:取真实几率(攻击方,挨打方) >= math.random(100) then --
        return true
    end
end

function 法术:取真实几率(攻击方,挨打方)
    return 攻击方.抗性.分花几率
end

function 法术:取几率(攻击方,挨打方)
    local qm = 攻击方.亲密 or 0
    return 15
end

function 法术:法术取描述(攻击方, 挨打方)
    return string.format("分花拂柳，出其不意。#r【消耗MP】0#r#G物理攻击杀死一个单位时，有%s%%几率继续追击下个单位，最多追击3个单位。",攻击方.抗性.分花几率)
end

function 法术:计算_召唤(P)
    P.抗性.分花几率 = P.抗性.分花几率 + 15
end

return 法术
