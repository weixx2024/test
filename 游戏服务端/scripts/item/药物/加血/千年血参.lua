
local 物品 = {
    名称 = '千年血参',
    叠加 = 999,
    类别 = 1,
    类型 = 1,
    对象 = 12,
    条件 = 63,
    绑定 = false,
    排序 = 20000
}

function 物品:使用(对象)
    if 对象:增减气血(20000) then
        self.数量 = self.数量 - 1
    end
end

return 物品
