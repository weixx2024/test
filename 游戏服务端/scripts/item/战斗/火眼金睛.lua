-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 00:49:34
local 物品 = {
    名称 = '火眼金睛',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 12,
    条件 = 37,
    绑定 = false,
}

function 物品:使用(对象, 来源)
    if 对象.是否战斗 or 对象.取主人 or 对象.是否怪物 then
        for key, v in 对象:遍历我方() do
            v:删除BUFF('隐身')
            v.是否隐身 = false
        end
        self.数量 = self.数量 - 1
    end
end

return 物品
