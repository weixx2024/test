local 物品 = {
    名称 = '华韵流光',
    叠加 = 999,
    类别 = 1,
    类型 = 3,
    对象 = 12,
    条件 = 63,
    绑定 = false,
    排序 = 1
}

function 物品:使用(对象)
    local q = math.floor(对象.最大气血 * 1)
    local m = math.floor(对象.最大魔法 * 1)
    对象:双加(q,m)
    self.数量 = self.数量 - 1
end

return 物品
