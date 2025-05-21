local 物品 = {
    名称 = '清盈果',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
function 物品:初始化()
    if not self.参数 then
        self.参数 = 1000
    end
end

function 物品:使用(对象)
    if 对象:添加体力(self.参数) then
        对象:常规提示("#Y你恢复了" .. self.参数 .. "点体力！")
        self.数量 = self.数量 - 1
    else
        对象:常规提示("#Y你体力已满！")
    end
end

function 物品:取描述()
    if self.参数 then
        return self.参数 .. "点体力"
    end
    return "#Y未知参数"
end

return 物品
