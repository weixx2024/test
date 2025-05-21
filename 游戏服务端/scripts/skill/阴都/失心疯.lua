local 法术 = {
    类别= '门派',
    类型= 1,
    对象= 2,
    条件= 37,
    名称= '失心疯',
    id = 2004,
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for i, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local 几率 = self:法术取几率(攻击方, v)
        if math.random(100) < 几率 then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = self:法术取回合()
                b.挣脱率 = 100 - 几率
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

function 法术:法术取几率(攻击方, 挨打方)
    local 几率 = 86
    几率 = 几率 + 3.6 * self.熟练度 ^ 0.3
    几率 = (几率 + 攻击方.忽视抗遗忘 - 挨打方.抗遗忘) * (1 + 攻击方.加强遗忘 *
        0.01)
    -- if math.random( 100 )<=攻击方.遗忘暴击几率  then
    --     几率=几率*1.5
    -- end
    几率 = 几率 * math.random(70, 100) * 0.01

    return 几率
end

function 法术:法术取回合()
    if self.熟练度 >= 9600 then
        return 6
    elseif self.熟练度 >= 5800 then
        return 5
    elseif self.熟练度 >= 2300 then
        return 4
    else
        return 3
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.175) }
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取描述()
    return string.format('鬼上身,使敌方丧心病狂,行事疯癫。每个技能都有80%%几率被溃忘,无法使用物品，目标人数1人,持续#R%s#G个回合。'
        , self:法术取回合())
end

BUFF = {
    法术 = '失心疯',
    名称 = '遗忘',
    id = 1701
}
法术.BUFF = BUFF
function BUFF:BUFF回合开始(单位) --挣脱
    if math.random(100) < self.挣脱率 then
        self:删除()
    end
    --目标:取法术("脱困术")
end

function BUFF:BUFF法术施放前(src)
    local 法术 = src.当前法术
    return not self.遗忘[法术.名称]
end

function BUFF:BUFF物品使用前(src)
    local 物品 = src.当前物品
    return not self.遗忘[物品.名称]
end

function BUFF:BUFF添加后(buff, 目标)
    if buff == self then
        self.遗忘 = {}
        for k, v in 目标:遍历法术() do
            if math.random(100) <= 80 then
                self.遗忘[v.名称] = true
            end
        end
        目标:删除BUFF('混乱')
        目标:删除BUFF('昏睡')
        目标:删除BUFF('中毒')
    end
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end
return 法术