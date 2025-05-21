local 物品 = {
    名称 = '符文',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.等级 < self.使用等级 then
        对象:常规提示('#Y使用该符文需要等级大于%s。', self.使用等级)
        return
    end
    local rw = 对象:取任务(self.类型)
    if rw then
        if rw.属性 == self.属性 then
            rw:添加时长(1)
        else
            rw:删除()
        end
    end
    local r = 生成任务 { 名称 = self.类型 }
    r:添加任务(对象, self)
    self.数量 = self.数量 - 1
end

return 物品
