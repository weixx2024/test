-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2024-04-29 14:56:46

local 物品 = {
    名称 = '化形丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false,
}

function 物品:使用(对象)
    if 对象:使用化形丹() then
        self.数量= self.数量 - 1
    end
end

return 物品
