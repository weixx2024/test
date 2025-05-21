local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '西天净土',
    id = 9005,
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
            b.效果 = self:法术取BUFF效果(攻击方, v)
        end
    end

end

function 法术:回合开始()
    if self.冷却回合 then
        self.冷却回合 = self.冷却回合 - 1
        if self.冷却回合 <= 0 then
            self.冷却回合 = nil
        end
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        self.冷却回合 = 5
    end
end

function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 效果 = {
        土 = 100
    }
    for k, v in pairs(效果) do
        挨打方[k] = 挨打方[k] + v
    end
    return 效果
end

function 法术:法术取回合()
    return 3
end

function 法术:法术取目标数()
    return 10
end

function 法术:法术取消耗()
    return { 消耗MP = 12600 }
end

function 法术:法术取描述()

    return string.format('西天净土，暮鼓晨钟，洗荡心神提高敌方全体土五行。#R【消耗MP】#R12600#G提高敌方全体土五行，持续3回合,冷却时间5回合。')
end

BUFF = {
    法术 = '西天净土',
    名称 = '五行',
    id = 2927
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF添加前(buff, 目标)
    if self == buff then
        目标:删除BUFF('五行')
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        for k, v in pairs(self.效果) do
            单位[k] = 单位[k] - v
        end
    end
end

return 法术
