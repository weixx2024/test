local 物品 = {
    名称 = '元宵礼包',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加物品({
        生成物品 { 名称 = '神兵礼盒', 数量 = 30, 参数 = 1 },
        生成物品 { 名称 = '积分卡', 参数 = 1500, 数量 = 1 },
        生成物品 { 名称 = '汤小圆礼盒', 数量 = 1, 参数 = 10000000 },

    }) then
        self.数量 = self.数量 - 1
    end

end

return 物品
