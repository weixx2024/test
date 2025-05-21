local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '万毒攻心',
    id = 105,
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
        local n = self:法术取伤害(攻击方, v)
        攻击方.伤害 = n
        v:被法术攻击(攻击方, self)
        local b = v:添加BUFF(BUFF)
        if b then
            b.回合 = self:法术取回合()
            b.毒伤害 = n
        end
    end
    if 攻击方.是否玩家 then
        self.熟练度 = self.熟练度 < self.熟练度上限 and self.熟练度 + 1 or self.熟练度上限
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
end

function 法术:法术基础伤害(攻击方)
    local 等级 = 攻击方.等级
    local 伤害 = 等级 * (1.73261 * self.熟练度 ^ 0.4)

    -- if 攻击方.伤筋动骨~=nil then
    --     伤害=伤害*(1+攻击方.伤筋动骨*0.1)
    -- end

    return math.floor(伤害)
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = self:法术基础伤害(攻击方)
    伤害 = 取中毒伤害(伤害, 攻击方, 挨打方)
    return math.floor(伤害)
end

function 法术:法术取回合()
    if self.熟练度 >= 12000 then
        return 7
    elseif self.熟练度 >= 9600 then
        return 6
    elseif self.熟练度 >= 5800 then
        return 5
    elseif self.熟练度 >= 2300 then
        return 4
    else
        return 3
    end
end

function 法术:取目标数()
    if self.熟练度 >= 11864 then
        return 7
    elseif self.熟练度 >= 5215 then
        return 6
    elseif self.熟练度 >= 1638 then
        return 5
    elseif self.熟练度 >= 226 then
        return 4
    else
        return 3
    end
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.721) }
end

function 法术:法术取描述()
    return string.format('给对手#R%s#G人造成#R%s#G个回合中毒伤害。',
        self:法术取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '万毒攻心',
    名称 = '中毒',
    id = 105
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('昏睡')
    end
end

function BUFF:BUFF回合开始(目标)
    -- if math.random(100) < self.挣脱率 then
    --     self:删除()
    --     return
    -- end

    if not 目标.是否死亡 then
        self.毒伤害 = math.floor(self.毒伤害 * 0.75)
        目标:减少气血(self.毒伤害)
    end
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
