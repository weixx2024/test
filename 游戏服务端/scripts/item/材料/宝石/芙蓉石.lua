local 物品 = {
    名称 = '芙蓉石',
    叠加 = 0,
    类别 = 3,
    类型 = 0,
    对象 = 0,
    条件 = 0,
    是否高级宝石 = true,
    绑定 = false,
}
function 物品:初始化()
    if not self.等级 then
        self.等级 = 1
    end
end

function 物品:使用(对象)
end

function 物品:取描述(对象)
    if self.品质 then
        return string.format("#Y等级 %s，%s + %s  品质 %s", self.等级, self.宝石属性, self.宝石数值,
            self.品质)
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
