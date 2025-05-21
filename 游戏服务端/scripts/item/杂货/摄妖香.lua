local 物品 = {
    名称 = '摄妖香',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)

    if 对象.是否玩家 then
        local sxy = 对象:取任务('摄妖香')
        if sxy then
            sxy:添加时间()
        else
            对象:添加任务('摄妖香')
        end
        self.数量 = self.数量 - 1
        对象:常规提示("#Y你使用了摄妖香")
    end
end

return 物品
