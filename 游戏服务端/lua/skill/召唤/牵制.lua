local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '牵制',
}
local BUFF
function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150

end

function 法术:召唤进入战斗(攻击方,数据,召唤)
    local b = 召唤:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end


function 法术:法术取描述(攻击方, 挨打方)
    return "具有此技能的召唤兽在场时，敌方所有人物的连击次数不超过3次(不计算第一次攻击，仅限玩家之间PK时使用)。"
end

BUFF = {
    法术 = '牵制',
    名称 = '牵制',
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF回合结束(单位)

end

function BUFF:BUFF取效果(自己,目标)
    return true
end

return 法术
