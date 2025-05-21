local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 7,
    名称 = '妙手回春',
    id = 2133,
}

local BUFF
function 法术:进入战斗(攻击方, 目标)
    self.已释放 = nil
end

function 法术:法术施放(攻击方, 目标, 战场)

    if 攻击方.战场.回合数 < 3 then
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
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        v:增加气血(math.floor(v.最大气血 * 0.5))
        if v.气血 > 0 then
            v.是否死亡 = false
        end
        v:可视增加魔法(math.floor(v.最大魔法 * 0.5))
    end

end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        self.已释放 = true
    end

end

function 法术:法术取目标数() --现在就是恢复3个啊  那就过
    return 3
end

function 法术:法术取消耗(攻击方)
    return { 消耗MP = 12600 }
end

function 法术:法术取描述()

    return '#W妙手回春，起死回生。#r#W【消耗MP】12600#r#G给己方三个单位回复50%的气血与50%的法力，每场战斗只能使用一次，前3回合不可使用'
end

return 法术
