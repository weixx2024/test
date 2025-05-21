local 物品 = {
    名称 = '龙马礼盒',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    禁止交易 = self,
    绑定 = true
}

function 物品:使用(对象)
    if 对象:添加召唤(生成召唤 { 名称 = "龙马", 禁止交易 = self, 禁止摆摊 = true, 类型 = 0 }) then
        self.数量 = self.数量 - 1
    end

end

return 物品
