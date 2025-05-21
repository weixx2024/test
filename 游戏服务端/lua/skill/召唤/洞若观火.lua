local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '洞若观火',
    id = 0137,
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
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
end

function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 效果 = { 抗震慑 = 0 }
    效果.抗震慑 = 12
    挨打方.抗震慑 = 挨打方.抗震慑 - 效果.抗震慑
    return 效果
end

function 法术:法术取回合()
    return 2
end

function 法术:取目标数()
    return 1
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取消耗()
    return { 消耗MP = 1280 }
end

function 法术:法术取描述()
    return string.format(
        '#r#W【消耗MP】#R1280#r#G对敌方使用时降低12%%抗震慑,目标人数#R%s#G人，持续#R%s#G个回合。'
        , self:取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '洞若观火',
    名称 = '减震慑',
    id = 1182
}
法术.BUFF = BUFF
function BUFF:BUFF添加前(来源, 目标)

end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.抗震慑 = 单位.抗震慑 + self.效果.抗震慑
    end
end

return 法术
