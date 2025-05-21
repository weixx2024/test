local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '春暖花开',
    id = 2151,
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
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        self.冷却回合 = 10
        for _, v in ipairs(目标) do
            for i,n in pairs(v.法术列表) do
                if n.冷却回合 and n.名称 ~= self.名称 then --
                    if n.冷却回合>=10 and n.是否终极 then
                        self.冷却回合 = 20
                    end
                    n.冷却回合 = nil
                end
            end
        end
    end
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

function 法术:法术取消耗(攻击方)
    return { 消耗MP = 12 }
end

function 法术:法术取描述()

    return '#W刷新本方单个召唤兽中所有处于冷却的技能，冷却10回合。如被刷新的技能中包含10回合之后才可使用的终极技能，冷却20回合。'
end

return 法术
