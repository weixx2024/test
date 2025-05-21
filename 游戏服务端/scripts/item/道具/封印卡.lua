local 物品 = {
    名称 = '封印卡',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加召唤(生成召唤 { 名称 = self.参数 }) then
        self.数量 = self.数量 - 1
    end
end

function 物品:取描述(对象)
    if self.参数 then
        return '#Y 封印召唤兽：' .. self.参数
    end

end

return 物品
