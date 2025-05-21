local 物品 = {
    名称 = '超级神兽丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.类型 == 1 and not 对象.宝宝 then
        return '#Y 野生召唤兽无法使用该道具！'
    end


    if 对象:添加经验(8880000) then
        self.数量 = self.数量 - 1
        对象:提示窗口('#Y你的' .. 对象.名称 .. '获得了#R8880000#Y经验')
    else
        return '#Y 当前召唤兽已达等级上限！'
    end
end

return 物品
