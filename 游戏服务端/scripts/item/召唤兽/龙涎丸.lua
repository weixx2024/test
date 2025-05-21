local 物品 = {
    名称 = '龙涎丸',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    if 对象.类型==1 and not 对象.宝宝 then
        return '#Y 野生召唤兽无法使用该道具！'
    end
    local r = 对象:使用龙涎丸()

    if r == 3 then
        self.数量 = self.数量 - 1
        对象:常规提示('#Y%s一口吞下龙涎丸，奇迹发生了！#145',对象.名称)
    elseif r == 2 then
        return '#Y 当前召唤兽食用次数已达上限，无法食用！'
    else
        return '#Y 当前召唤兽类型无法食用！'
    end

end

return 物品
