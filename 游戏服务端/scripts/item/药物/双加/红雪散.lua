local 物品 = {
    名称 = '红雪散',
    叠加 = 999,
    类别 = 1,
    类型 = 3,
    对象 = 12,
    条件 = 63,
    绑定 = false,
    排序 = 30000
}

function 物品:使用(对象)
    对象:双加(30000,30000)
    self.数量 = self.数量 - 1
end

return 物品
