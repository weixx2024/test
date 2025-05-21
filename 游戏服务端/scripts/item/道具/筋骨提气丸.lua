local 物品 = {
    名称 = '筋骨提气丸',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    local r = 对象:取乘骑坐骑()
    if r then
        local v = r:筋骨提气丸()
        if  type(v)=="string" then
            return v
        else
            self.数量=self.数量-1
        end
    else
        return "#Y请先将要操作的坐骑设置乘骑状态！"
    end
end

return 物品
