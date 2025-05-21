local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '报复',
	id = 2127,
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
    return "在敌方第一个施法单位施法前对其造成气血伤害，此技能只生效一次(仅限玩家之间PK时使用)。"
end

BUFF = {
    法术 = '报复',
    名称 = '报复',
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF回合结束(单位)

end

function BUFF:BUFF取效果(自己,目标)
    return math.floor(目标.最大气血*0.1)
end

return 法术
