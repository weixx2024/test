local 物品 = {
    名称 = '五常神兽宝卷',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}


local _五常神兽范围 = {'颜如玉','五叶','浪淘沙','范式之魂','垂云叟'}

function 物品:使用(对象)
    local mc = _五常神兽范围[math.random( #_五常神兽范围)]
    if 对象:添加召唤(生成召唤 { 名称 =mc }) then
        self.数量 = self.数量 - 1
    end
end

return 物品

