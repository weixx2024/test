-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-09-26 23:03:18
-- @Last Modified time  : 2024-09-26 23:11:39

local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '如来神掌',
    是否被动 = true,
}
local BUFF
function 法术:进入战斗(攻击方)

end

function 法术:取倍率(攻击方, 挨打方)
    local gl = math.random(120)  --  以前是60
    if gl <= 30 then
        return 2
    elseif gl <= 50 then
        return 3
    else
        return 4
    end
end

function 法术:物理攻击(攻击方,挨打方,数据)
    local 倍率 = self:取倍率(攻击方, 挨打方)
    攻击方.伤害 = math.floor(攻击方.伤害*倍率)
    攻击方.倍率=倍率
    攻击方:当前喊话("如来神掌#2")
end

function 法术:法术取描述(攻击方, 挨打方)
    return "无所从来 亦无所去 一切法见 于我无碍。物理攻击时一定几率对攻击目标产生多倍伤害，最多为四倍伤害"
end

function 法术:计算_召唤(P)

end


return 法术

