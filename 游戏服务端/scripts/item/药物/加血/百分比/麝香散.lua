local 物品 = {
    名称 = '麝香散',
    叠加 = 999,
    类别 = 1,
    类型 = 1,
    对象 = 12,
    条件 = 63,
    绑定 = false,
    排序 = 0.4
}

function 物品:使用(对象)
    if 对象.气血 >= 对象.最大气血 then
        return
    end
    local 数额=math.floor( 对象.最大气血*0.4 )
    对象:增减气血(数额)
    self.数量 = self.数量 - 1
end

return 物品
