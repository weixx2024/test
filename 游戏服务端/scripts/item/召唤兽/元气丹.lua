local 物品 = {
    名称 = '元气丹',
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

    if 对象.原名 ~= self.参数 then
        对象:常规提示("#Y你的召唤兽闻了闻元气丹的气味，不愿意服用这元气丹。")
        return
    end
    local n = _随机可食用(3, 对象.原名)
    if not n then
        对象:常规提示("#Y该类型唤兽不可使用！")
        return
    end
    local 成长 = true
    local 变色 = false
    -- if math.random(100) < 30 then --爆正常几率
    --     成长 = true
    -- end
    if math.random(100) < 30 then --变色几率
        变色 = true
    end


    if 对象:食用元气丹(成长, 变色, n) then
        对象:常规提示("#Y您的召唤兽一口吞下元气丹，身体发生了一些奇异的变化。")
        self.数量 = self.数量 - 1
    end


end

function 物品:取描述()
    if self.参数 then
        return self.参数
    end
end

return 物品
