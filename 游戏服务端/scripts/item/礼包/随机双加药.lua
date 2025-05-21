local 物品 = {
    名称 = '随机双加药',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}


local _药品范围 = {
    { 名称 = '清风白雪', 数量 = 10, 几率 = 60 },
    { 名称 = '餐风饮露', 数量 = 8, 几率 = 60 },
    { 名称 = '白露为霜', 数量 = 8, 几率 = 50 },
    { 名称 = '红雪散', 数量 = 6, 几率 = 50 },
    { 名称 = '孔雀明王羽', 数量 = 5, 几率 = 50 },
    { 名称 = '五龙圣丹', 数量 = 5, 几率 = 50 },

}

function 物品:使用(对象)
    if not 对象:取包裹空位() then
        对象:提示窗口('#Y 你的包裹已经满了！')
        return
    end
    local t --= false
    while not t do
        for _, v in ipairs(_药品范围) do
            if math.random(100) <= v.几率 then
                t = v
                break
            end
        end
    end
    if t then
        if 对象:添加物品({
            生成物品 { 名称 = t.名称, 数量 = t.数量 }
        }) then
            self.数量 = self.数量 - 1
        end
    end



end

return 物品
