local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '气贯长虹',
    id = 0126
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
    local 效果 = { 致命几率 = 9, 狂暴几率 = 9, 命中率 = 9 }
    挨打方.致命几率 = 挨打方.致命几率 + 效果.致命几率
    挨打方.狂暴几率 = 挨打方.狂暴几率 + 效果.狂暴几率
    挨打方.命中率 = 挨打方.命中率 + 效果.命中率
    return 效果
end

function 法术:法术取回合()
    return 2
end

function 法术:取目标数()
    return 2
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取消耗()
    return { 消耗MP = 1260 }
end

--fuck 曹
function 法术:法术取描述(P)
    return string.format('将气势如长虹的力量灌输给自己，予以对手致命打击。增加狂暴致命率。\n#G目标人数#R%s#G人，持续#R%s#G个回合。', self:取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '加物理',
    名称 = '加物理',
    id = 126
}
法术.BUFF = BUFF
function BUFF:BUFF添加前(来源, 目标)

end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.致命几率 = 单位.致命几率 - self.效果.致命几率
        单位.狂暴几率 = 单位.狂暴几率 - self.效果.狂暴几率
        单位.命中率 = 单位.命中率 - self.效果.命中率
    end
end

return 法术
