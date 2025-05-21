local 物品 = {
    名称 = 'VIP4等级礼包',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.VIP < 4 then
        对象:修改VIP等级(4)
        self.数量 = self.数量 - 1
    end
end

return 物品
