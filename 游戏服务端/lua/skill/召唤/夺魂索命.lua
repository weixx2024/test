local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 7,
    名称 = '夺魂索命',
    id = 2315,
}

local BUFF
function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
end

function 法术:法术施放(攻击方, 目标, 战场)
    local 消耗mp = self:法术取消耗(攻击方).消耗MP
    if 攻击方.是否怪物 then
        消耗mp = 0
    end
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    if self.冷却回合 then
        攻击方:提示("#R剩余冷却回合:" .. self.冷却回合)
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        if v.是否死亡 and self:取几率(攻击方) >= math.random(100) then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = 3
            -- b.效果 = self:法术取BUFF效果(攻击方, v)
            end
        end
    end

end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        self.冷却回合 = 10
    end

end

function 法术:回合开始()
    if self.冷却回合 then
        self.冷却回合 = self.冷却回合 - 1
        if self.冷却回合 <= 0 then
            self.冷却回合 = nil
        end
    end
end

function 法术:取几率(攻击方)
    local qm = 攻击方.亲密 or 0
    local 几率 = 20 + SkillXS(qm,0.5)
    return 几率
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗(攻击方)
    return { 消耗MP = 12600 }
end

function 法术:法术取描述()
    return '#W夺魂索命，另敌方无法复活。#r#W【消耗MP】20000#r#G有几率成功锁定单体目标魂魄（目标必须为倒地单位）,使其无法被任何法术,药品等复活。冷却10回合。'
end

BUFF = {
    法术 = '夺魂索命',
    名称 = '夺魂索命',
    id = 2315
}
法术.BUFF = BUFFc
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        -- 目标:删除BUFF('夺魂索命')
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
