local 物品 = {
    名称 = '金丹',
    叠加 = 999,
    对象 = 3,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:修改天资(self.名称) then
        self.数量 = self.数量 - 1
    end
end

return 物品
