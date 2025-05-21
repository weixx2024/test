local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '复生',
    种族 = 2 --天界
}

local BUFF
function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150
    攻击方.复生次数 = 0
end


BUFF = {
    法术 = '复生',
    名称 = '复生',
    --  id = 401
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始(单位) --挣脱

end

function BUFF:BUFF死亡处理(攻击方, 挨打方)
    if 挨打方 then
        if 挨打方.是否死亡 and math.random(100) <= 300 and 挨打方.复生次数 < 3 then
           return true
        end
    end
end

function BUFF:BUFF死亡处理结果(攻击方, 挨打方)
    挨打方:增加气血(math.floor(挨打方.最大气血*1), 2152)
    挨打方.是否死亡 = false
    挨打方.复生次数 = 挨打方.复生次数 + 1
    if 挨打方.复生次数 == 3 then
        self:删除()
    end
end

return 法术
