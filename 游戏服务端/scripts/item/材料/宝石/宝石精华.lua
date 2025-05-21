local 物品 = {
    名称 = '宝石精华',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 1,
    条件 = 0,
    绑定 = false,
}
function 物品:初始化()
   
end

function 物品:使用(对象)
    local 临时宝石 = 对象:随机新宝石(1)
    if  对象:添加物品({
             生成物品 { 名称 = 临时宝石.名称, 等级 = 临时宝石.等级, 品质 = 临时宝石.品质, 宝石属性 = 临时宝石.类型, 宝石数值 = 临时宝石.数值 ,禁止交易 = self.禁止交易},
         }) then
        self.数量 = self.数量 - 1
    end
end

function 物品:取描述(对象)
   
    return string.format("#Y右键使用可以获得随机1级宝石，也是装备镶嵌、摘除宝石时的必要材料！")
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
