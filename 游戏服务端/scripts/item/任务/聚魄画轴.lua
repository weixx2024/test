local 物品 = {
    名称 = '聚魄画轴',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    禁止交易 = true,
}

function 物品:使用(对象)
    local r = 对象:取任务("日常_大雁塔副本")
    if not r then
        对象:提示窗口('#Y 你身上没有任务！')
        return
    end
    if r.进度 ~= 8 then
        return
    end

    local map = 对象:取当前地图()
    if map and r.地图 then
        if map.id == r.地图[2].id then
            r:刷出怪物(2)
            对象:最后对话("怪物首领已现行")
            self.数量 = self.数量 - 1
        end
    end
end

return 物品
