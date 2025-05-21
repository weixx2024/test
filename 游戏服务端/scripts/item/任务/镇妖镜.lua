local 物品 = {
    名称 = '镇妖镜',
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
    if r.进度 ~= 2 then
        return
    end

    local map = 对象:取当前地图()
    if map and self.mapid == map.id then
        r:刷出怪物(1)
        对象:最后对话("怪物首领已现行")
        self.数量 = self.数量 - 1
        -- if math.abs(self.x - 对象.X) < 5 and math.abs(self.y - 对象.Y) < 5 then
        --     r:刷出怪物(1)
        --     对象:最后对话("怪物首领已现行")
        --     self.数量 = self.数量 - 1
        -- else
        --     对象:提示窗口('#Y请到指定的地方使用！')
        -- end
    end
end

function 物品:取描述()
end

return 物品
