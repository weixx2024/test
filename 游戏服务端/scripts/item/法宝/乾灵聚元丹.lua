local 物品 = {
    名称 = '乾灵聚元丹',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加法宝经验(175845, '乾灵聚元丹', 120) then
        self.数量=self.数量-1
    end
end

return 物品
