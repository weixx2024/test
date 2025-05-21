-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 00:49:34
local 物品 = {
    名称 = '竹扫帚',
    叠加 = 999,
    类别 = 3,
    类型 = 0,
    对象 = 48,
    条件 = 37,
    绑定 = false,
}

function 物品:使用(对象, 来源)
    if 对象.是否怪物 then
        if 对象:取战斗脚本() ~= 'scripts/event/活动4_金玉满堂.lua' then
            return
        end
        self.数量 = self.数量 - 1
        return 0.45
    end
end

return 物品
