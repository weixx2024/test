local 物品 = {
    名称 = '超级人参果王',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加经验(18000000) then
        self.数量 = self.数量 - 1
    else
        对象:提示窗口('#Y 你等级已经达到上限，无法食用！')
    end
end

return 物品
