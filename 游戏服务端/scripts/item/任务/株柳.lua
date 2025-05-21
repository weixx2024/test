-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2022-07-04 10:34:53
local 物品 = {
    名称 = '株柳',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    禁止交易 = true,
}

function 物品:使用(对象)
    local r = 对象:取任务("清明_侍魂_善鬼_插柳")
    if not r then
        对象:提示窗口('#Y 你身上没有任务！')
        return
    end


    local map = 对象:取当前地图()
    if map and self.mapid == map.id then
        if math.abs(self.x - 对象.X) < 5 and math.abs(self.y - 对象.Y) < 5 then
            r:插柳(对象)
            self.数量 = self.数量 - 1
        else
            对象:提示窗口('#Y 要在指定的地方插柳哦！')
        end
    end
end

function 物品:取描述()
    if self.map then
        return "#Y" .. self.map
    end

end

return 物品
