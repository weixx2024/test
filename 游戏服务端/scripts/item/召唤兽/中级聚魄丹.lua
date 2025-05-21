local 物品 = {
    名称 = '中级聚魄丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local t = 对象:强开技能格子(ture,"中级聚魄丹")
    if type(t) == "string" then
        return t
    elseif t then
        self.数量 = self.数量 - 1
        对象:提示窗口('#Y你的' .. 对象.名称 .. '已开启一个技能格子！')
    else
        self.数量 = self.数量 - 1
        对象:提示窗口('#Y开启技能格子失败，你损失了一枚聚魄丹！')
    end
end

return 物品
