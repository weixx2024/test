local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '吸血水蛭',
    id = 1901,
}

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    self.吸血值 = {}
    for i, v in ipairs(目标) do
        攻击方.伤害 = self:法术取伤害(攻击方, v)
        v:被法术攻击(攻击方, self)
        self.吸血值[i] = 攻击方.伤害
    end
    if 攻击方.是否玩家 then
        self.熟练度 = self.熟练度 < self.熟练度上限 and self.熟练度 + 1 or self.熟练度上限
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh=false
    end
    local list = {}
    local px = {}
    for _, v in 攻击方:遍历我方() do
        if v.是否玩家 and v.是否死亡 and not v:取BUFF('封印') then
            px[v] = math.random( 150,200 )
            table.insert(list, v)
        elseif not v.是否死亡 and not v:取BUFF('封印') then
            table.insert(list, v)
        end
    end

    table.sort(list, function(a, b)
        local aa = a.是否死亡 and px[a] or a.气血 < a.最大气血 and (a.气血 / a.最大气血) or -1
        local bb = b.是否死亡 and px[b] or b.气血 < b.最大气血 and (b.气血 / b.最大气血) or -1
        return aa > bb
    end)
    for i, v in ipairs(目标) do
        if list[i] and self.吸血值 then 
            if self.吸血值[i] then
                local n = math.floor(self.吸血值[i] * 2 * (1 + list[i].加强三尸虫回血程度 * 0.01))
                list[i]:增加气血(n)
            end
        end
    end

    self.吸血值 = {}
end
function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = 0
    local 等级 = 攻击方.等级 + 1
    伤害 = 18.766 * 等级 + 攻击方.加强三尸虫
    伤害 = 强克伤害加成(攻击方, 挨打方, 伤害)
    伤害 = 取鬼法伤害(攻击方, 挨打方, 伤害)
    if math.random(100) < 攻击方.三尸虫狂暴几率 then
        伤害 = 伤害 * (1.5 + 攻击方.三尸虫狂暴程度 * 0.01)
        挨打方.伤害类型 = "狂暴"
    end
    伤害 = 伤害 - 挨打方.抗三尸虫
    if 伤害 <= 0 then
        伤害 = 1
    end
    return math.floor(伤害)
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.107) }
end

function 法术:法术取描述()
    return string.format('利用水蛭吸取对方的血液,并化为己用。可将伤害的一定百分比化为己方所用，目标人数1人。')
end

return 法术
