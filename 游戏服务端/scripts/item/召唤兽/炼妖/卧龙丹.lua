local 物品 = {
    名称 = '卧龙丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    炼妖石 = true,
    是否炼妖 = true,
    绑定 = false
}

function 物品:使用(对象)
    local r = 对象:清空炼妖石()
    if type(r) == "string" then
        对象:提示窗口(r)
    elseif r == true then
        对象:提示窗口("#Y炼妖成功")
        self.数量 = self.数量 - 1
        return true
    end
end

return 物品
