local 物品 = {
    名称 = '随机天书召唤兽',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}


local _随机天书召唤兽 = {
    { 名称 = '剑精灵', 几率 = 10 },
    { 名称 = '罗刹鬼姬', 几率 = 50 },
    { 名称 = '雷兽', 几率 = 50 },
    { 名称 = '狮蝎', 几率 = 50 },
    { 名称 = '冥灵妃子', 几率 = 10 },
    { 名称 = '哥俩好', 几率 = 100 },
}

function 物品:使用(对象)
    local mc = '冥灵妃子'
    for k, v in pairs(_随机天书召唤兽) do
        if math.random(270) <= v.几率 then
            mc = v.名称
            break
        end
    end
    if 对象:添加召唤(生成召唤 { 名称 = mc }) then
        self.数量 = self.数量 - 1
    end
end

return 物品
