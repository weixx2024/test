local 物品 = {
    名称 = '银票',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}
function 物品:生成(数量, 参数)
    self.数量 = 数量
    if not self.参数 then
        self.参数 = 1000000
    end
end

function 物品:使用(对象)
    对象:添加银子(self.参数)
    self.数量 = self.数量 - 1
end

function 物品:取描述()
    if self.参数 then
        return string.format("#Y%s两银子", self.参数)
    end
end

return 物品
