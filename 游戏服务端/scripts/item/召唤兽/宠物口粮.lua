local 物品 = {
    名称 = '宠物口粮',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    local r = 对象:添加忠诚度(2)
    if  r ==true then
        self.数量=self.数量-1
    else
        return '#Y 当前召唤兽食用数量已达上限！'
    end

end

return 物品
