local 物品 = {
    名称 = '黑宝石',
    叠加 = 0,
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    是否宝石 = true,
    绑定 = false,
}
function 物品:初始化()
    if not self.等级 then
        self.等级 = 1
    end

    self:生成属性()

end

local _属性 = {
    { "反震程度", 1, 1 },
    { "反震率", 1, 1 },
    { "敏捷", 1, 1 },
    { "附加攻击", 50, 60 },
}
local _没价值 = {
    附加气血 = true,
    附加魔法 = true,
    附加攻击 = true,
    连击次数 = true,
    反击次数 = true,
    耐久 = true,
}
local _反击次数 = { 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3 }
local _连击次数 = { 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3 }
function 物品:取对应属性()
    if self.宝石属性 then
        for i, v in ipairs(_属性) do
            if v[1] == self.宝石属性 then
                return _属性[i]
            end
        end
        return _属性[math.random(#_属性)]
    end
end

function 物品:生成属性()
    local t = _属性[math.random(#_属性)]
    if self.宝石属性 then
        t = self:取对应属性()
    end
    self.宝石属性 = t[1]
    if self.宝石属性 == "反击次数" then
        self.宝石数值 = _反击次数[self.等级] or 1
    elseif self.宝石属性 == "连击次数" then
        self.宝石数值 = _连击次数[self.等级] or 2
    else
        self.宝石数值 = (math.random(t[2], t[3])) * self.等级
        self.宝石数值 = self.宝石数值 < 2 and 2 or self.宝石数值
    end
    if not _没价值[self.宝石属性] then
        if not self.价值 then
            self.价值 = math.random(80, 130)
        end
        self.宝石数值 = math.floor(self.宝石数值 * self.价值 * 0.1) * 0.1
    end

end

function 物品:使用(对象)

end

function 物品:取描述(对象)
    if self.价值 then
      return string.format("#Y等级 %s，%s + %s%%  价值 %s", self.等级, self.宝石属性, self.宝石数值,
            self.价值)
    end
    return string.format("#Y等级 %s，%s + %s", self.等级, self.宝石属性, self.宝石数值)
end
function 物品:取回收价格(对象)
    if self.等级 == 6 then
        return 150000
    elseif self.等级 == 7 then
        return 250000
    elseif self.等级 == 8 then
        return 450000
    end
end
return 物品
