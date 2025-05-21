local 法术 = {
    类别 = '符文',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '分裂攻击',
    是否被动 = true,
}

local BUFF = {
    法术 = '分裂攻击',
    名称 = '分裂攻击',
    几率 = 0
}

法术.BUFF = BUFF

function 法术:进入战斗(攻击方)
    BUFF.几率 = 攻击方.分裂攻击
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

function BUFF:BUFF回合开始()
    self.触发 = false
end

function BUFF:BUFF分裂攻击()
    if math.random(100) <= self.几率 and not self.触发 then
        self.触发 = true
        return true
    end
end

return 法术
