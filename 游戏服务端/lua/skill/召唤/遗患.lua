-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-10-29 16:59:44
-- @Last Modified time  : 2024-11-05 17:29:04

local 法术 = {
    类别 = '召唤',
    类型 = 0,
    条件 = 1,
    对象 = 2,
    名称 = '遗患',
    id = 2122,

}

local BUFF
function 法术:进入战斗(攻击方)
    if 攻击方:是否PK() then --
        local b = 攻击方:进入战斗添加BUFF(BUFF)
        b.回合 = 150
    end
end

function 法术:召唤进入战斗(攻击方,数据,召唤)
    if 攻击方:是否PK() then --
        local b = 召唤:进入添加BUFF(BUFF)
        b.回合 = 150
        数据:添加BUFF(2122,召唤.位置)
    end
end


function 法术:法术取描述(P)
    return "斩草除根，不留遗患。#r【消耗MP】0#r#G在敌方第一个施法单位施法前对其造成法力伤害，此技能只生效一次!"
end

BUFF = {
    法术 = '遗患BUFF',
    名称 = '遗患BUFF',
	id = 2122
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF回合结束(单位)

end

function BUFF:BUFF取效果(自己,目标)
    return math.floor(目标.最大魔法*0.1)
end

return 法术
