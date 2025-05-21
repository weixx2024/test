local 法术 = {
    类别 = '属性',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '每回合HP',
    是否被动 = true,
}
local BUFF
function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

function 法术:是否触发(攻击方, 挨打方)

end

BUFF = {
    法术 = '每回合HP',
    名称 = '每回合HP',
}
法术.BUFF = BUFF
function BUFF:BUFF回合开始(自己)
    if 自己.气血 > 0 then
        自己:增加气血(自己.每回合HP)
    end

end

return 法术
