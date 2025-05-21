local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '涅槃',
    是否被动 = true,
	id = 2152,
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

function 法术:是否触发(攻击方, 挨打方)

end

function 法术:取伤害(攻击方, 挨打方)

end

function 法术:法术取描述(攻击方, 挨打方)
    return "召唤兽死亡时有几率复活，并清除所有状态"
end


BUFF = {
    法术 = '涅槃',
    名称 = '涅槃',
    --  id = 401
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始(单位) --挣脱

end

function BUFF:BUFF死亡处理(攻击方, 挨打方)
    if 挨打方 then
        if 挨打方.是否死亡 and math.random(100) <= 30 then
           return true
        end
    end
end

function BUFF:BUFF死亡处理结果(攻击方, 挨打方)
    挨打方:增加气血(math.floor(挨打方.最大气血*1), 2152)
    挨打方.是否死亡 = false
    挨打方.涅槃重生 = 1
    self:删除()
    挨打方:删除所有BUFF()
end

return 法术
