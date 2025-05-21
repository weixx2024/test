local 物品 = {
    名称 = '高级孔明灯',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    排序 = 0,
    多坐标飞行旗 = true,
}
function 物品:初始化()
    self.次数 = 99
    self.坐标 = {}
end

function 物品:取坐标列表()
    local s = ''
    for i, v in ipairs(self.坐标) do
        s = s .. string.format('%d|%s(%d,%d)\n', i, v.名称, v.X, v.Y)
    end
    return s
end

function 物品:使用(对象)
    local map = 对象:取当前地图()
    if map and map.是否副本 then
        对象:提示窗口('#Y该地图禁止使用传送道具。')
        return
    end
    if #self.坐标 == 0 then
        if map.是否副本 then
            对象:提示窗口('#Y该地图禁止使用传送道具。')
            return
        end
        table.insert(self.坐标, { 名称 = map.名称, id = map.id, X = 对象.X, Y = 对象.Y })
        对象:提示窗口("#Y你做好了路标。")
        return
    end
    local 对话 = '选择路标\nmenu\n' .. self:取坐标列表() .. '新增路标'
    local r = 对象:选择窗口(对话)
    if not 对象.是否组队 and not 对象.是否队长 then
        对象:提示窗口('#Y只有队长才可以使用该道具')
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
    for i, v in ipairs(self.坐标) do --选中路标传送
        if r == tostring(i) then
            对象:切换地图(self.坐标[i].id, self.坐标[i].X, self.坐标[i].Y)
            self.次数 = self.次数 - 1
            if self.次数 <= 0 then
                self.数量 = self.数量 - 1
            end
            return
        end
    end
    if r == '新增路标' then --记录坐标
        if map.是否副本 then
            对象:提示窗口('#Y该地图禁止使用传送道具。')
            return
        end
        if #self.坐标 < 8 then
            table.insert(self.坐标, { 名称 = map.名称, id = map.id, X = 对象.X, Y = 对象.Y })
            对象:提示窗口('#Y你做好了路标。')
        else
            local 对话2 = '你已经记录了8处路标，要替换哪一处？\nmenu\n' .. self:取坐标列表()
            local t = 对象:选择窗口(对话2)
            for i, v in ipairs(self.坐标) do --选中路标替换
                if t == tostring(i) then
                    self.坐标[i].id = map.id
                    self.坐标[i].X = 对象.X
                    self.坐标[i].Y = 对象.Y
                    self.坐标[i].名称 = map.名称
                    对象:提示窗口('#Y你做好了路标。')
                    return
                end
            end
        end
    end
end

function 物品:小地图使用飞行旗(对象, 坐标)
    local r = 对象:选择窗口('你要到#G%s(%d,%d)#W吗？\nmenu\n1|快送我过去\n2|什么也不做', 坐标.名称, 坐标.X, 坐标.Y)

    if r == '1' then
        if not 对象.是否组队 and not 对象.是否队长 then
            对象:提示窗口('#Y只有队长才可以使用该道具')
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

        对象:切换地图(坐标.id, 坐标.X, 坐标.Y)

        self.次数 = self.次数 - 1
        if self.次数 <= 0 then
            self.数量 = self.数量 - 1
        end
    end
end

function 物品:取描述()
    if not self.坐标 then
        self.次数 = 99
        self.坐标 = {}
    end

    local r = ""
    for k, v in pairs(self.坐标) do
        r = r .. string.format('#G%s(%s,%s)#r', self.坐标[k].名称, self.坐标[k].X, self.坐标[k].Y)
    end

    return string.format('#G%s#r#Y还可以使用#R%s#Y次', r, self.次数)
end

return 物品
