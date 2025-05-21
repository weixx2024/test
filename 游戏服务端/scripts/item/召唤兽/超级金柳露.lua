local 物品 = {
    名称 = '超级金柳露',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local n = 0
    if math.random(100) <= 50 then
        n = _随机可食用(3, 对象.原名)
    end
    local r = 对象:使用金柳露(100, 100, n)
    if type(r) == "string" then
        对象:提示窗口(r)
    elseif r == true then
        对象:提示窗口("#G" .. 对象.名称 .. "#Y获得了新的属性！")
        self.数量 = self.数量 - 1
    end
end

return 物品
