local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 7,
    名称 = '绝境逢生',
    id = 2133,
}

local BUFF
function 法术:进入战斗(攻击方, 目标)--来试试
    self.已释放 = nil
end

function 法术:召唤进入战斗(攻击方, 目标)
    self.已释放 = nil
end


function 法术:法术施放(攻击方, 目标, 战场)
    if 攻击方.战场.回合数 < 1 then
        攻击方:提示("#R前3回合无法释放！")
        return false
    end
    local 消耗mp = self:法术取消耗(攻击方).消耗MP
    if 攻击方.是否怪物 then
        消耗mp = 0
    end
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    if self.已释放 then
        攻击方:提示("#R整场战斗只可以释放一次")
        return false
    end
    --  黄泉一笑
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        v:增加气血(math.floor(v.最大气血 * 0.6))
        if v.气血 > 0 then
            v.是否死亡 = false
        end
        v:可视增加魔法(math.floor(v.最大魔法 * 0.6))
    end
end


function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        self.已释放 = true
    end
end

function 法术:法术取目标数()
    return 10
end

function 法术:法术取消耗(攻击方)
    return { 消耗MP = 12600 }
end

function 法术:法术取描述()

    return '#W枯木亦可逢春，释放巨大的战意，使己方再燃战斗之力。#r#W【消耗MP】0#r#G给己方所有单位回复60%气血与60%法力，每场战斗只能使用一次。3回合后才可使用。'
end

return 法术
