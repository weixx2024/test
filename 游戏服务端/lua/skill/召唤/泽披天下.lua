local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '泽披天下',
    id = 2124,
}

local BUFF
function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
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
        local b = v:添加BUFF(BUFF)
        if b then
            b.回合 = 3
            b.父目标 = 攻击方
        end
    end

end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.冷却回合 = 5
        self.xh = false
    end
end

function 法术:法术取BUFF效果(攻击方, 挨打方)

end

function 法术:法术取回合()
    return 3
end

function 法术:法术取目标数()
    return 10
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
    return { 消耗MP = 12600 }
end

function 法术:法术取描述(P)
    return string.format("给己方所有在场单位施加庇护状态（死亡和封印单位除外），白泽可为有此状态的成员承担部分血伤，且自身所受血伤弱化，状态持续三回合。")
end

BUFF = {
    法术 = '泽披天下',
    名称 = '泽披天下',
    id = 2648
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF受到伤害前(攻击方, 挨打方,数据)
    local 父目标 = self.父目标
    if 父目标 and not 父目标.是否死亡 then
        local 差额 = math.ceil(攻击方.伤害*0.3)
        攻击方.伤害 = 攻击方.伤害 - 差额
        父目标:减少气血(差额)
    end
end

function BUFF:BUFF添加前(buff, 目标)
    if self == buff then
        目标:删除BUFF('泽披天下')
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
