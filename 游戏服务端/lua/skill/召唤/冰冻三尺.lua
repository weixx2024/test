local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '冰冻三尺',
    id = 2120,
}

local BUFF
function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
end

function 法术:取几率(攻击方, 挨打方)
    local qm = 攻击方.亲密 or 0
    return math.floor(15 + SkillXS(qm,0.05))
end

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
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
        if self:取几率(攻击方) >= math.random(100) then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = 3
            end
        end
    end

end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        self.冷却回合 = 5
    end
end

function 法术:法术取回合()
    return 3
end

function 法术:法术取目标数()
    return 1
end

function 法术:回合开始()
    if self.冷却回合 then
        self.冷却回合 = self.冷却回合 - 1
        if self.冷却回合 <= 0 then
            self.冷却回合 = nil
        end
    end
end

function 法术:法术取消耗()
    return { 消耗MP = 3600 }
end

function 法术:法术取描述()

    return string.format('水属性单体控制，有几率使目标无法使用法术、物品、法宝以及物理攻击，持续两回合，冷却时间5回合')
end

BUFF = {
    法术 = '冰冻三尺',
    名称 = '冰冻三尺',
    id = 2120
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function BUFF:BUFF物理攻击前(攻击方, 挨打方)
    if math.random(100) <= 50 then
        return false
    end
end

function BUFF:BUFF法术施放前(攻击方, 挨打方)
    if math.random(100) <= 50 then
        return false
    end
end

function BUFF:BUFF物品使用前(攻击方, 挨打方)
    if math.random(100) <= 50 then
        return false
    end
end

return 法术
