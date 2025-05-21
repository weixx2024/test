local 物品 = {
    名称 = '神兵石礼包',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加物品({
        生成物品 { 名称 = '神兵石', 数量 = 100 },


    }) then
        self.数量 = self.数量 - 1
    end

end

return 物品
