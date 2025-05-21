-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2024-04-19 15:36:27
local 物品 = {
    名称 = '坐骑礼包',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)

    if 对象:添加物品({
        生成物品 { 名称 = '一坐卡', 数量 = 1, 禁止交易 = true },
        生成物品 {名称 = '二坐卡', 数量 = 1, 禁止交易 = true },
        生成物品 {名称 = '三坐卡', 数量 = 1, 禁止交易 = true},
        生成物品 {名称 = '四坐卡', 数量 = 1, 禁止交易 = true},
        生成物品 {名称 = '五坐卡',  数量 = 1, 禁止交易 = true},
        生成物品 {名称 = '六坐卡', 数量 = 1, 禁止交易 = true},      
    }) then
       对象.其它.回血 = 1
       self.数量 = self.数量 - 1
       else
    return '#Y空间不足'
    end

end

return 物品
