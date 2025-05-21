-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 10:34:53
local 物品 = {
    名称 = '祭祖酒',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local r = 对象:取任务("元宵_新春祭祖")
    if r then
        if math.abs(r.x - 对象.X) < 5 and math.abs(r.y - 对象.Y) < 5 then
            r:触发战斗(对象)
        else
            对象:常规提示("#Y请前往"..r.位置.."使用！")
        end
    end
end

return 物品
