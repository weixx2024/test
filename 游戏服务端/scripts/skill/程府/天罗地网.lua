local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '天罗地网',
    id = 403,
    程府 = true
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for i, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local 几率 = self:法术取几率(攻击方, v)
        local 成功 = 几率 >= 100 and true or math.random(100) <= 几率
        if 成功 then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = self:法术取回合()
                b.挣脱率 = 100 - 几率
            end
        end
    end
    if 攻击方.是否玩家 then
        self.熟练度 = self.熟练度 < self.熟练度上限 and self.熟练度 + 1 or self.熟练度上限
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
end

function 法术:法术基础几率()
    return 32 + 3.6 * self.熟练度 ^ 0.3
end

function 法术:法术取几率(攻击方, 挨打方)
    local 几率 = self:法术基础几率()
    几率 = 取人法几率('封印', 几率, 攻击方, 挨打方)
    return 几率
end

function 法术:法术取回合()
    if self.熟练度 >= 9600 then
        return 5
    elseif self.熟练度 >= 5800 then
        return 4
    elseif self.熟练度 >= 2300 then
        return 3
    else
        return 2
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.178) }
end

function 法术:取目标数()
    local n = 2
    if self.熟练度 >= 9866 then
        n = 5
    elseif self.熟练度 >= 3098 then
        n = 4
    elseif self.熟练度 >= 428 then
        n = 3
    end
    return n
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    return string.format('用冰冻封印的方式让对手#R%s#G人#R%s#G个回合无法进行攻击但是其他人也无法伤害他。'
    , self:取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '天罗地网',
    名称 = '封印',
    id = 401
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始() --挣脱
    -- if math.random(100) < self.挣脱率 then
    --     self:删除()
    -- end
    --目标:取法术("脱困术")
end

function BUFF:BUFF指令开始()
    return false
end

function BUFF:BUFF被物理攻击前()
    return false
end

function BUFF:BUFF被法术攻击前()
    return false
end

function BUFF:BUFF添加前(buff, 目标)
    if buff.名称 ~= "封印" then
        return false
    end
end

function BUFF:BUFF物品使用前(src)
    return false
end

function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('混乱')
        目标:删除BUFF('昏睡')
        目标:删除BUFF('中毒')
        目标:删除BUFF('遗忘')
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    elseif math.random(100) < self.挣脱率 then
        self:删除()
    end
end

return 法术
