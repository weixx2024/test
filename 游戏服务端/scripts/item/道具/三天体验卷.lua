local 物品 = {
    名称 = '三天体验卷',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象:添加月卡(259200) then  --3600*24*3  秒
        self.数量 = self.数量 - 1
        对象:提示窗口('#Y 你使用了'..self.名称..'！')
    end
end

return 物品
