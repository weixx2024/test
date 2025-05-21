

local 物品 = {
    名称 = '青月灵草',
    叠加 = 999,
    类别 = 1,
    类型 = 1,
    对象 = 12,
    条件 = 63,
    绑定 = false,
    排序 = 15000
}

function 物品:使用(对象)
    if 对象:增减气血(15000) then
        self.数量 = self.数量 - 1
    end
end

return 物品
