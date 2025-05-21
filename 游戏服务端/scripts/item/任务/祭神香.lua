-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 10:34:53
local 物品 = {
    名称 = '祭神香',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}
local 对话 = [[
我想得到:
menu
1|九彩云龙珠(价值130)
2|星梦石
3|高级炼妖石
]]

function 物品:使用(对象)
    --todo 任务验证  范围验证
    local map = 对象:取当前地图()
    if map and map.id == 101386 then
        if 对象.X < 115 and 对象.X > 105 and 对象.Y < 155 and 对象.Y > 125 then
            local rw = 对象:取任务('孔庙祭祀_祭拜')
            if rw then
                local r = 对象:选择窗口(对话)
                if r then
                    self.数量 = self.数量 - 1
                    对象:常规提示("#R获得XXX奖励 出场")
                    rw:完成(对象)
                end

            else
                对象:常规提示('#Y你已经完成过本次祭拜')
            end
        else
            对象:提示窗口('#Y请在#R（115，105）-（155，125）#Y区域内使用祭神香进行祭拜')
        end
    else
        对象:常规提示('#Y只能在孔庙进行祭拜')
    end




end

return 物品
