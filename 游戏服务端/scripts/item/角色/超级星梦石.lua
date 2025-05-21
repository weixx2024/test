local 物品 = {
    名称 = '超级星梦石',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local r = 对象:人物洗点()
    if r==true then
        self.数量 = self.数量 - 1
    else
        对象:常规提示(r)
    end


end

return 物品
