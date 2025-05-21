local 物品 = {
    名称 = '百里香',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local sxy = 对象:取任务('摄妖香')
    if sxy then
        self.数量 = self.数量 - 1
        sxy:删除()
        对象:常规提示("#Y你解除了摄妖香的效果")
    else
        对象:常规提示("#Y当前身上没有摄妖香状态")
    end

end

return 物品
