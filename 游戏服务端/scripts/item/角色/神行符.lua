local 物品 = {
    名称 = '神行符',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local r = 生成任务 { 名称 = '神行符' }
    r:添加任务(对象)
    self.数量 = self.数量 - 1
end

return 物品
