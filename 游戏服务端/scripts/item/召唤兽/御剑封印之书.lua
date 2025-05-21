local 物品 = {
    名称 = '御剑封印之书',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.等级 < 50 or not 对象.宝宝 then
        对象:提示窗口("#Y请与等级大于等于50级宝宝合成！")
        return
    end
    if 对象.是否参战 or 对象.是否观看 then
        对象:提示窗口("#Y请先取消该召唤参战或者观看状态！")
        return
    end
    if 对象:添加召唤兽("剑精灵") then
        对象:丢弃()
        self.数量 = self.数量 - 1
    end
end

return 物品
