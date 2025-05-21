local 法术 = {
    类别 = '法宝',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '幽冥鬼手',
    id = 1506
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
    return 1
end

local _等级 = { 0, 20, 65, 112, 158}
function 法术:法术取回合()
    local h = 2
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
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    local h = 2
    for i, v in ipairs(_等级) do
        if self.等级 >= v then
            h = h + 1
        else
            break
        end
    end
    local bl = 43 + math.floor(self.等级 * 0.35) * 0.01
    return string.format("在%s回合内物理攻击用内力震荡其他对手造成%s%%的隔山打牛伤害", h, bl)
end

BUFF = {
    法术 = '幽冥鬼手',
    名称 = '幽冥鬼手',
    id = 1506
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始() --挣脱

end

function BUFF:物理攻击(攻击方, fdst)
    local bl = 43 + math.floor(self.等级 * 0.35) * 0.01
    local dst = fdst:随机我方(
        1,
        function(v)
            if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') and (not fdst or fdst ~= v) then
                return true
            end
        end
    )
    if dst[1] then
        攻击方.伤害 = math.floor(攻击方.伤害 * bl * 0.01)
        if 攻击方.伤害 < 1 then
            攻击方.伤害 = 1
        end
        dst[1]:被法术攻击(攻击方, self)
    end

end

function BUFF:BUFF指令开始(对象) --昏睡

end

function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        -- 目标:删除BUFF('银索金铃')
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
