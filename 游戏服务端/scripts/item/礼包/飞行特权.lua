local 物品 = {
    名称 = '飞行特权',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.VIP < 3 then
        对象:修改VIP等级(3)
    end
    对象.其它.无限飞 = 1
    self.数量 = self.数量 - 1
end

return 物品
