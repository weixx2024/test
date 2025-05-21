local 物品 = {
    名称 = '超级变色丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}
function 物品:初始化(t)



end

function 物品:使用(对象)
    if not 对象.元气丹 or 对象.元气丹==0 then
        对象:常规提示("#Y只有食用了元气丹的召唤兽才可以食用变色丹哟！")
        return
    end
    local 变色 = false
    if math.random(100) < 100 then --变色几率
        变色 = true
    end
    if 对象:食用变色丹(变色) then
        --对象:常规提示("#Y您的召唤兽一口吞下元气丹，身体发生了一些奇异的变化。")
        self.数量 = self.数量 - 1
    end


end

function 物品:取描述()
    if self.参数 then
        return self.参数
    end
end

return 物品
