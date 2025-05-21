local 物品 = {
    名称 = '内丹精华',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    if 对象:添加元气(10000) then
        self.数量 = self.数量 - 1
    end
end

return 物品