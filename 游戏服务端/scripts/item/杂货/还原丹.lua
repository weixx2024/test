local 物品 = {
    名称 = '还原丹',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local bsk = 对象:取任务('变身卡')
    if bsk then
        self.数量 = self.数量 - 1
        bsk:删除()
        对象:刷新外形()
        对象:常规提示("#Y你解除了变身卡的效果")
    else
        对象:常规提示("#Y当前身上没有变身卡状态")
    end
end

return 物品
