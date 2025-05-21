local 物品 = {
    名称 = '范式之魂召唤卡',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加召唤(生成召唤 { 名称 ="范式之魂" }) then
        self.数量 = self.数量 - 1
    end
end

return 物品

