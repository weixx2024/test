local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '挥戈回日',
    id = 1901,
}

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗(攻击方).消耗MP
    if 攻击方.是否怪物 then
        消耗mp = 0
    end
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    --  self.吸血值 = {}
    
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        for i, v in ipairs(目标) do
            if not v:取BUFF('封印') then
                v:增加气血(1000)
            end
        end
    end
end



function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗(攻击方)
    local n = 0
    if 攻击方 then
        n = math.floor(攻击方.最大魔法 * 0.5)
    end
    return { 消耗MP = n }
end

function 法术:法术取描述()
    return '消耗法力上限50%的法力值，为已方一个单位回复N的HP。（主动）'
end

return 法术
