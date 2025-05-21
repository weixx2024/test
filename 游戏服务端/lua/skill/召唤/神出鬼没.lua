local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '神出鬼没',
}

function 法术:取效果(攻击方)
    local qm = 攻击方.亲密 or 0
    local dj = 攻击方.等级
    local zs = 攻击方.转生
    return math.floor(170 + SkillXS(qm,1.08) + dj * 0.1 + zs * 2)
end


-- function 法术:计算_召唤(P)
--     P.速度 = P.速度 + self:取效果(P)
-- end

local BUFF
function 法术:召唤进入战斗(攻击方,数据,目标,闪现)
    if 数据 then
        local b = 目标:进入添加BUFF(BUFF)
        if b then
            b.回合 = 4
            数据:添加BUFF("隐身",目标.位置)
            目标.是否隐身 = true
            b.效果 = self:法术取BUFF效果(攻击方, 目标)
        end
    end
end

function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 效果 = { 速度 = self:取效果(挨打方) }
    效果.速度 =self:取效果(挨打方)
    挨打方.速度 = 挨打方.速度 + 效果.速度
    return 效果
end


function 法术:法术取描述(攻击方, 挨打方)
    return string.format("有几率无需召唤自动加入战斗，增加召唤兽SP#r#R%s进场时立即隐身！",self:取效果(攻击方))
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
        if self.效果 then
            for i,v in pairs(self.效果) do
                单位[i] =  单位[i] - v
            end
        end
    end
end

return 法术
