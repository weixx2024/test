-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2024-03-16 21:31:34
local 物品 = {
    名称 = '祝福劵',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 0,
    绑定 = false
}

function 物品:初始化()

end

function 物品:初始化()
end

function 物品:使用(对象)
    对象:祝福券()
    self.数量 = self.数量 - 1
end

function 物品:取描述()
end

return 物品

-- function 物品:使用(对象)
--     self.数量 = self.数量 - 1
--     local map = 对象:取当前地图()
--     if map then
--         map:普通同庆()
--         local mapname = map.名称
--         对象:发送系统("#C%s#W在#Y%s#W使用了祝福券,该地图所有玩家获得一小时三倍时间祝福！#33", 对象.名称, mapname)
--     end


-- end


-- return 物品
