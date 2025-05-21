local 物品 = {
    名称 = '灵犀角',
    叠加 = 0,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    炼妖石 = true,
    是否炼妖 = true,
    绑定 = false
}
function 物品:初始化()
    if not self.参数 then
        self.参数 = 1
    end
end

function 物品:使用(对象)
    local r = 对象:使用炼妖石(self.参数, "抗混乱")
    if type(r) == "string" then
        对象:提示窗口(r)
    elseif r == true then
        对象:提示窗口("#Y炼妖成功")
        self.数量 = self.数量 - 1
        return true
    end
end

function 物品:取描述()
    if self.参数 then
        return string.format("#Y抗混乱 +%s", self.参数)
    end
end

return 物品
