local 物品 = {
    名称 = '还我漂漂丹',
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
        bsk.外形 = 对象.原形
        对象:刷新外形()
        self.数量 = self.数量 - 1
    else
        对象:常规提示("#Y当前身上没有变身卡状态")
    end
end

return 物品
