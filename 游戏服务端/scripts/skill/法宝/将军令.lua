local 法术 = {
    类别 = '法宝',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '将军令',
    id = 1502
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗怨气 = self:法术取消耗().消耗怨气
    if 攻击方:取怨气() < 消耗怨气 then
        攻击方:提示("#R怨气不足，无法释放！")
        return false
    end
    self.xh = 消耗怨气
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local 成功 = true
        if 成功 then
            local b = v:添加BUFF(BUFF)
            if b then
                b.等级 = self.等级
                b.回合 = self:法术取回合()
            end
        end
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少怨气(self.xh)
        self.xh = false
    end
end

function 法术:法术取消耗()
    return { 消耗怨气 = self.等级 + 150 }
end

function 法术:取目标数()
    return 2
end

local _等级 = { 0, 20, 60, 80, 112, 156, 200 }

function 法术:法术取描述()
    local h = 1
    for i, v in ipairs(_等级) do
        if self.等级 >= v then
            h = h + 1
        else
            break
        end
    end
    local bl = 5.3 + math.floor(self.等级 * 0.2) * 0.01
    return string.format("在%s回合内将遭受的%s%%伤害转移给对方成员", h, bl)
end

function 法术:法术取回合()
    local h = 1
    for i, v in ipairs(_等级) do
        if self.等级 >= v then
            h = h + 1
        else
            break
        end
    end
    return h
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.气血 > b.气血
    end
end

BUFF = {
    法术 = '将军令',
    名称 = '将军令',
    id = 1502
}
法术.BUFF = BUFF





function BUFF:BUFF被物理攻击前(攻击方, 挨打方)
    local bl = 5.3 + math.floor(self.等级 * 0.2) * 0.01

    local 伤害 = math.floor(攻击方.伤害 * bl * 0.01)
    if 伤害 < 1 then
        伤害 = 1
    end

    攻击方.伤害 = 攻击方.伤害 - 伤害
    local dst = 攻击方:随机我方(
        1,
        function(v)
            if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') then --and (not 攻击方 or 攻击方 ~= v)
                return true
            end
        end
    )
    if dst[1] then
        挨打方.伤害 = 伤害
        dst[1]:被法术攻击(挨打方, self)
    end
end

function BUFF:BUFF被法术攻击前(攻击方, 挨打方)
    local bl = 5.3 + math.floor(self.等级 * 0.2) * 0.01

    local 伤害 = math.floor(攻击方.伤害 * bl * 0.01)
    if 伤害 < 1 then
        伤害 = 1
    end
    攻击方.伤害 = 攻击方.伤害 - 伤害
    local dst = 攻击方:随机我方(
        1,
        function(v)
            if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') then --and (not 攻击方 or 攻击方 ~= v)
                return true
            end
        end
    )

    if dst[1] then
        dst[1]:减少气血(伤害)
    end
end

function BUFF:BUFF添加后(buff, 目标)
    if self == buff then

    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
