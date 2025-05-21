local 物品 = {
    名称 = '龙涎丸宝卷',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}


local _龙涎丸宝卷范围 = {
    { 名称 = '吉祥果', 几率 = 50 },
    { 名称 = '天龙女', 几率 = 50 },
    { 名称 = '铁扇公主', 几率 = 50 },
    { 名称 = '九戒', 几率 = 100 },
}

function 物品:使用(对象)
    local mc = '天龙女'
    for k, v in pairs(_龙涎丸宝卷范围) do
        if math.random(250) <= v.几率 then
            mc = v.名称
            break
        end

    end
    if 对象:添加召唤(生成召唤 { 名称 =mc }) then
        self.数量 = self.数量 - 1
    end


end

return 物品
