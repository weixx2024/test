local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '回源',
	id = 2126,
}
local BUFF
function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150

end

function 法术:召唤进入战斗(攻击方,数据,召唤)
    local b = 召唤:进入添加BUFF(BUFF)
    b.回合 = 150
end


function 法术:法术取描述(攻击方, 挨打方)
    return "有几率在友方单位使用法术时为其回复50%法力。"
end

BUFF = {
    法术 = '回源',
    名称 = '回源',
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF回合结束(单位)

end

function 法术:取几率(攻击方)
    local qm = 攻击方.亲密 or 0
    return 20 + SkillXS(qm,0.7)
end

function BUFF:BUFF取效果(自己,目标)
    if 法术:取几率(自己) >= math.random(100) then
        return true
    end
    return false
end

return 法术
