local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '春回大地',
    无视封印 = true,
    id = 0129,
}

local BUFF
function 法术:进入战斗(攻击方, 目标)
    self.已释放 = nil
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
    if self.已释放 then
        攻击方:提示("#R整场战斗只可以释放一次")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        v:删除BUFF('混乱')
        v:删除BUFF('封印')
        v:删除BUFF('昏睡')
        v:删除BUFF('中毒')
        v:删除BUFF('遗忘')
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
    return { 消耗MP = 1 }
end

function 法术:法术取描述()

    return '#W春回大地，万物复苏。#r#W【消耗MP】21000#r#G解除本方全体任何状态，整场战斗只可使用一次。'
end

return 法术
