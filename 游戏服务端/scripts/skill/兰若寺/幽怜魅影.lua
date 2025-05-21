local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 3,
    条件 = 37,
    名称 = '幽怜魅影',
    id = 1701,
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local b = v:添加BUFF(BUFF)
        if b then
            b.回合 = self:法术取回合()
            if 攻击方:是否我方(v) then
                b.效果 = self:法术取BUFF效果_我方(攻击方, v)
                b.敌我 = 1
            else
                b.效果 = self:法术取BUFF效果_敌方(攻击方, v)
                b.敌我 = 2
            end

        end
    end
    if 攻击方.是否玩家 then
        self.熟练度 = self.熟练度 < self.熟练度上限 and self.熟练度 + 1 or self.熟练度上限
    end
end
function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh=false
    end
end

function 法术:法术取BUFF效果_我方(攻击方, 挨打方)
    local 效果 = { 抗震慑 = 0, 抗遗忘 = 0, 抗鬼火 = 0, 抗三尸虫 = 0, 抗毒伤害 = 0 }
    效果.抗震慑 = math.floor(8 * (1 + 攻击方.加强魅惑 * 0.01) * 100) * 0.01
    效果.抗遗忘 = math.floor(5 * (1 + 攻击方.加强魅惑 * 0.01) * 100) * 0.01
    效果.抗鬼火 = math.floor(self:取鬼火() * (1 + 攻击方.加强魅惑 * 0.01) * 100) * 0.01
    效果.抗三尸虫 = math.floor(self:取三尸() * (1 + 攻击方.加强魅惑 * 0.01))
    效果.抗毒伤害 = math.floor(self:取毒伤害() * (1 + 攻击方.加强魅惑 * 0.01))
    for k, v in pairs(效果) do
        挨打方.抗性[k] = 挨打方.抗性[k] + v
    end
    return 效果
end

function 法术:法术取BUFF效果_敌方(攻击方, 挨打方)
    local 效果 = { 抗震慑 = 0, 抗遗忘 = 0, 抗鬼火 = 0, 抗三尸虫 = 0, 抗毒伤害 = 0 }
    效果.抗震慑 = math.floor(8 * (1 + 攻击方.加强魅惑 * 0.01) * 50) * 0.01
    效果.抗遗忘 = math.floor(5 * (1 + 攻击方.加强魅惑 * 0.01) * 50) * 0.01
    效果.抗鬼火 = math.floor(self:取鬼火() * (1 + 攻击方.加强魅惑 * 0.01) * 50) * 0.01
    效果.抗三尸虫 = math.floor(self:取三尸() * (1 + 攻击方.加强魅惑 * 0.01) * 0.5)
    效果.抗毒伤害 = math.floor(self:取毒伤害() * (1 + 攻击方.加强魅惑 * 0.01) * 0.5)
    for k, v in pairs(效果) do
        挨打方.抗性[k] = 挨打方.抗性[k] - v
    end
    return 效果
end

function 法术:法术取回合()
    if self.熟练度 >= 14300 then
        return 6
    elseif self.熟练度 >= 9600 then
        return 5
    elseif self.熟练度 >= 5800 then
        return 4
    elseif self.熟练度 >= 2300 then
        return 3
    else
        return 2
    end
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.113) }
end

function 法术:取鬼火()
    return math.floor((5 + self.熟练度 ^ 0.29583) * 100) * 0.01
end

function 法术:取三尸()
    return math.floor(1985 + self.熟练度 ^ 0.75865)
end

function 法术:取毒伤害()
    return math.floor(4287 + self.熟练度 ^ 0.81963)
end

function 法术:法术取描述()
    return string.format('对己方使用增加目标8%%抗震慑，5%%抗遗忘,#R%s%%#G抗鬼火,#R%s#G抗三尸虫,#R%s#G抗毒伤害,对敌方使用时降低对应抗性,效果减半，目标人数1人，持续#R%s#G个回合。'
        , self:取鬼火(), self:取三尸(), self:取毒伤害(), self:法术取回合())
end

BUFF = {
    名称 = '幽怜魅影',
    id = 1702
}
法术.BUFF = BUFF
function BUFF:BUFF添加前(来源, 目标)

end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        if self.敌我 == 1 then
            for k, v in pairs(self.效果) do
                单位.抗性[k] = 单位.抗性[k] - v
            end
        else
            for k, v in pairs(self.效果) do
                单位.抗性[k] = 单位.抗性[k] + v
            end
        end

    end
end

return 法术
