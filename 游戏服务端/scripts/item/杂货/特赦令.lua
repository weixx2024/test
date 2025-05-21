local 物品 = {
    名称 = '特赦令',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.是否玩家 then
        local r = 对象:取任务("坐牢")
        if r then
            r:使用特赦令(对象)
            self.数量 = self.数量 - 1
        end
    end


end

return 物品
