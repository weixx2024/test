local 物品 = {
    名称 = '高级飞行旗',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    排序 = 0,
    单坐标飞行旗 = true,
}
function 物品:初始化()
    self.次数 = 10
    self.坐标 = {}
end

function 物品:使用(对象)
    local map = 对象:取当前地图()
    if map and map.是否副本 then
        对象:提示窗口('#Y该地图禁止使用传送道具。')
        return
    end
    if self.坐标.名称 == nil then
        if map.是否副本 then
            对象:提示窗口('#Y该地图禁止使用传送道具。')
            return
        end
        self.坐标.名称 = map.名称
        self.坐标.id = map.id
        self.坐标.X = 对象.X
        self.坐标.Y = 对象.Y

        对象:提示窗口('#Y你做好了路标。')
        return
    end

    local 对话 = string.format('你要到#G%s(%d,%d)#W吗？\nmenu\n1|快送我过去\n\n2|重新做路标\n3|什么也不做'
    , self.坐标.名称, self.坐标.X, self.坐标.Y)
    local r = 对象:选择窗口(对话)
    -- if not 对象.是否组队 or not 对象.是否队长 then
    --     对象:提示窗口('#Y只有队长才可以使用该道具')
    --     return
    -- end
    if (对象.是否组队 and 对象:取队伍人数() > 1) or (对象.是否组队 and not 对象.是否队长) then --单人传送道具条件模板
        对象:提示窗口('#Y只有单人才可以使用该道具')
        return
    end
    for _, b in 对象:遍历队友() do
        for _, v in b:遍历任务() do
            if v.飞行限制 then
                for _, d in 对象:遍历队友() do
                    d:提示窗口('#Y%s身上有限制飞行的任务！', v.名称)
                end
                return
            end
        end
    end
    for _, v in 对象:遍历任务() do
        if v.飞行限制 then
            for _, d in 对象:遍历队友() do
                d:提示窗口('#Y%s身上有限制飞行的任务！', 对象.名称)
            end
            对象:提示窗口('#Y%s身上有限制飞行的任务！', 对象.名称)
            return
        end
    end
    if r == '1' then
        对象:切换地图(self.坐标.id, self.坐标.X, self.坐标.Y)
        self.次数 = self.次数 - 1
        if self.次数 <= 0 then
            self.数量 = self.数量 - 1
        end
    elseif r == '2' then
        map = 对象:取当前地图()
        self.坐标.名称 = map.名称
        self.坐标.id = map.id
        self.坐标.X = 对象.X
        self.坐标.Y = 对象.Y
        对象:提示窗口('#Y你做好了路标。')
    end
end

function 物品:小地图使用飞行旗(对象)
    self:使用(对象)
end

function 物品:取描述()
    if not self.坐标 then
        self.次数 = 10
        self.坐标 = {}
    end
    if self.坐标.名称 ~= nil then
        return string.format("#Y记录的坐标是%s(%s,%s)#r#Y还可以使用#R%s#Y次", self.坐标.名称, self.坐标
            .X, self.坐标.Y, self.次数)
    end

    return string.format("#G还可以使用%s次", self.次数)
end

return 物品
