local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '楚楚可怜',
    id = 903,
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
            b.效果 = self:法术取BUFF效果(攻击方, v)
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
function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 效果 = { 抗雷 = 0, 抗火 = 0, 抗水 = 0, 抗风 = 0, 物理吸收 = 0, 抗昏睡 = 0, 抗中毒 = 0,
        抗混乱 = 0, 抗封印 = 0 }
    local 抗仙法 = self:取仙法()
    抗仙法 = 抗仙法 * (1 + 攻击方.加强加防法术 * 0.01)
    效果.抗雷 = 抗仙法
    效果.抗火 = 抗仙法
    效果.抗水 = 抗仙法
    效果.抗风 = 抗仙法
    效果.物理吸收 = 抗仙法
    效果.抗昏睡 = 8
    效果.抗中毒 = 8
    效果.抗混乱 = 8
    效果.抗封印 = 8
    for k, v in pairs(效果) do
        挨打方[k] = 挨打方[k] + v
    end

    return 效果
end

function 法术:法术取回合()
    if self.熟练度 >= 19000 then
        return 7
    elseif self.熟练度 >= 12000 then
        return 6
    elseif self.熟练度 >= 6800 then
        return 5
    elseif self.熟练度 >= 3000 then
        return 4
    elseif self.熟练度 >= 1200 then
        return 3
    else
        return 2
    end
end

function 法术:取目标数()
    if self.熟练度 >= 8324 then
        return 5
    elseif self.熟练度 >= 2155 then
        return 4
    elseif self.熟练度 >= 214 then
        return 3
    else
        return 2
    end
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.178) }
end

function 法术:取仙法()
    local n = math.floor((7 + self.熟练度 ^ 0.321736) * 100) * 0.01
    return n
end

function 法术:法术取描述()

    return string.format('增加物理吸收和仙族四系法术抗性#R%s%%#G,增加人族法术抗性8%%,使用范围#R%s#G人，持续效果#R%s#G个回合。'
        ,
        self:取仙法(), self:法术取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '楚楚可怜',
    名称 = '盘',
    id = 901
}
法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        for k, v in pairs(self.效果) do
            单位[k] = 单位[k] - v
        end
    end
end

return 法术
