local 物品 = {
    名称 = 'VIP称谓符',
    叠加 = 1,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()

end

function 物品:使用(对象)

    for i = 1, 14 do
        对象:提升称谓(i)
    end
    self.数量 = self.数量 - 1
end

function 物品:取描述()

end

return 物品
