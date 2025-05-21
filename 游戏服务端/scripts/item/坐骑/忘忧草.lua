local 物品 = {
    名称 = '忘忧草',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local r = 对象:取乘骑坐骑()
    if not r then
        对象:常规提示("#Y清先将要坐骑设置为乘骑状态！")
        return
    end

    r:洗初值()
    对象:常规提示("#Y你的" .. r.名称 .. "发生了微妙变化！")
    self.数量 = self.数量 - 1





end

return 物品
