local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '隐身',
    id = 304,

}

local BUFF

function 法术:进入战斗(攻击方)
    -- local b = 攻击方:进入战斗添加BUFF(BUFF)
    -- b.回合 = 4
    -- 攻击方.是否隐身 = true
end

function 法术:召唤进入战斗(攻击方,数据,召唤)
    local b = 召唤:进入添加BUFF(BUFF)
    b.回合 = 3
    数据:添加BUFF("隐身",召唤.位置)
    召唤.是否隐身 = true
end


function 法术:法术取描述()
    return '进入战斗后，触发隐身状态'
end


BUFF = {
    法术 = '隐身',
    名称 = '隐身',
    id = '隐身'
}

法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.是否隐身 = false
    end
end

return 法术
