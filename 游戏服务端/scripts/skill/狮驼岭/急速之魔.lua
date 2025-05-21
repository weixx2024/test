local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '急速之魔',
    id = 1102
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
    local 效果 = { 速度 = 0 }
    效果.速度 = math.floor(挨打方.速度 * 0.16 * (1 + 攻击方.加强加速法术 * 0.01))
    挨打方.速度 = 挨打方.速度 + 效果.速度
    return 效果
end

function 法术:法术取回合()
    if self.熟练度 >= 23000 then
        return 11
    elseif self.熟练度 >= 18000 then
        return 10
    elseif self.熟练度 >= 15000 then
        return 9
    elseif self.熟练度 >= 10000 then
        return 8
    elseif self.熟练度 >= 5000 then
        return 7
    elseif self.熟练度 >= 2000 then
        return 6
    elseif self.熟练度 >= 700 then
        return 5
    elseif self.熟练度 >= 80 then
        return 4
    else
        return 3
    end
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.143) }
end

function 法术:法术取描述()
    return string.format('增加SP16%%，使用效果1人，持续效果#R%s#G个回合。', self:法术取回合())
end

BUFF = {
    法术 = '急速之魔',
    名称 = '速',
    id = 1101
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if buff == self then
        目标.战场.重新排序 = true
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.速度 = 单位.速度 - self.效果.速度
    end
end

return 法术
