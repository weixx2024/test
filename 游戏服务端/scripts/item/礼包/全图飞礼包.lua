-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2024-04-19 15:22:27
local 物品 = {
    名称 = '全图飞礼包',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    -- 对象:添加银子(50000000)
    if 对象:添加物品({

    }) then
        对象.其它.无限飞 = 1
        self.数量 = self.数量 - 1
    else
    return '#Y空间不足'
    end

end

return 物品
