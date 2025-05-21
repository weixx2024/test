local 物品 = {
    名称 = '蟠桃王',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    禁止交易 = true
}

function 物品:使用(对象)
    local r = 对象:添加法术熟练(666)
    if r then
        对象:提示窗口('#W你的法术#Y' .. r .. "#W增加了#R666#W点熟练度。")
        self.数量 = self.数量 - 1
    else
        对象:常规提示("#Y你的所有法术熟练度达到上限！")
    end
end

return 物品
