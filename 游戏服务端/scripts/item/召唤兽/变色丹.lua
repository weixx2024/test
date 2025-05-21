local 物品 = {
    名称 = '变色丹',
    叠加 = 0,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}
function 物品:初始化(t)

end

function 物品:使用(对象)
    if not 对象.元气丹 or 对象.元气丹 == 0 then
        对象:常规提示("#Y只有食用了元气丹的召唤兽才可以食用变色丹哟！")
        return
    end
    if 对象.原名 ~= self.参数 then
        对象:常规提示("#Y你的召唤兽闻了闻元气丹的气味，不愿意服用这元气丹。")
        return
    end
    local 变色 = false
    if math.random(100) < 50 then --变色几率
        变色 = true
    end
    if 对象:食用变色丹(变色) then
        self.数量 = self.数量 - 1
    end
end

function 物品:取描述()
    if self.参数 then
        return "#Y" .. self.参数
    end
end

function 物品:取回收价格(对象)
    return 50000
end

return 物品
