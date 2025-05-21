local 物品 = {
    名称 = '和合散',
    叠加 = 999,
    类别 = 1,
    类型 = 2,
    对象 = 12,
    条件 = 63,
    绑定 = false,
    排序 = 2500
}

function 物品:使用(对象)
    if 对象.魔法 >= 对象.最大魔法 then
        return
    end
    对象:增减魔法(2500)
    self.数量 = self.数量 - 1
end

return 物品
