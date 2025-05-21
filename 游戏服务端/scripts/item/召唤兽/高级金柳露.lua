local 物品 = {
    名称 = '高级金柳露',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local r=对象:使用金柳露(90,100)
    if type(r)=="string" then
        对象:提示窗口(r)
    elseif r == true then
        对象:提示窗口("#G"..对象.名称.."#Y获得了新的属性！")
        self.数量=self.数量-1
    end
end

return 物品
