local 物品 = {
    名称 = '超级亲密丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}
function 物品:初始化(t)
    if t then
    else
        self.参数 = 100000
    end

end

function 物品:使用(对象)
    local r = 对象:取主人飞升()
    if r == 1 then
        if 对象:添加亲密度(self.参数, 3) then
            self.数量 = self.数量 - 1
        else
            return "当前召唤兽亲密已达上限！"
        end
    else
        return "需要主人飞升才可以食用"
    end


end

function 物品:取描述()
    if self.参数 then
        return string.format("#Y+亲密%s", self.参数)
    end
end

return 物品
