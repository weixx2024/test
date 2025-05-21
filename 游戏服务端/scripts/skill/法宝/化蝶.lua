local 法术 = {
    类别 = '法宝',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '化蝶',
    id = 1517
}


function 法术:法术施放(攻击方, 目标)
    local 消耗怨气 = self:法术取消耗().消耗怨气
    if 攻击方:取怨气() < 消耗怨气 then
        攻击方:提示("#R怨气不足，无法释放！")
        return false
    end
    self.xh = 消耗怨气
    local bl = (15 + math.floor(self.等级 * 3) * 0.1)  * 0.01


    for _, v in ipairs(目标) do
        攻击方.伤害 = math.floor(攻击方.气血 * bl)
        v:被法术攻击(攻击方, self)
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少怨气(self.xh)
        攻击方:减少气血(攻击方.气血 - 1)
        self.xh = false
    end
end

function 法术:法术取消耗()
    return { 消耗怨气 = self.等级 + 150 }
end

function 法术:取目标数()
    return 1
end

function 法术:法术取回合()
    return 3
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    local bl = 15 + math.floor(self.等级 * 3) * 0.1
    return string.format("对对手造成施法者当前血量%s%%的伤害,使用后施法者当前血量变成1点", bl)
end

return 法术
