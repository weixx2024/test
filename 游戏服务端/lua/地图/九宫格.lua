local 九宫格 = class('九宫格')

function 九宫格:初始化(地图宽度, 地图高度)
    self.地图宽度 = 地图宽度
    self.地图高度 = 地图高度
    self.区域宽度 = math.floor(地图宽度 / 3)
    self.区域高度 = math.floor(地图高度 / 3)
    self.玩家列表 = {}
    self.区域玩家 = {}
    for i = 1, 9 do
        self.区域玩家[i] = {}
    end
end

function 九宫格:添加玩家(nid, x, y)
    local 区域索引 = self:计算区域索引(x, y)
    if not self.玩家列表[nid] then
        self.玩家列表[nid] = { x = x, y = y, 区域索引 = 区域索引 }
        table.insert(self.区域玩家[区域索引], nid)
    end
end

function 九宫格:删除玩家(nid)
    if self.玩家列表[nid] then
        local 区域索引 = self.玩家列表[nid].区域索引
        self.玩家列表[nid] = nil
        for i, v in ipairs(self.区域玩家[区域索引]) do
            if v == nid then
                table.remove(self.区域玩家[区域索引], i)
                break
            end
        end
    end
end

function 九宫格:更新玩家(nid, x, y)
    local 区域索引 = self:计算区域索引(x, y)
    if self.玩家列表[nid] then
        local 旧区域索引 = self.玩家列表[nid].区域索引
        if 区域索引 ~= 旧区域索引 then
            self.玩家列表[nid].x = x
            self.玩家列表[nid].y = y
            self.玩家列表[nid].区域索引 = 区域索引
            for i, v in ipairs(self.区域玩家[旧区域索引]) do
                if v == nid then
                    table.remove(self.区域玩家[旧区域索引], i)
                    break
                end
            end
            table.insert(self.区域玩家[区域索引], nid)
        else
            self.玩家列表[nid].x = x
            self.玩家列表[nid].y = y
        end
    end
end

function 九宫格:获取当前区域玩家(区域索引, x, y)
    if 区域索引 then
        return self.区域玩家[区域索引]
    else
        区域索引 = self:计算区域索引(x, y)
    end
    return self.区域玩家[区域索引]
end

function 九宫格:计算区域索引(x, y)
    local 列 = math.floor(x / self.区域宽度) + 1
    local 行 = math.floor(y / self.区域高度) + 1
    return (行 - 1) * 3 + 列
end

function 九宫格:取周围区域(x, y)
    local 相邻区域 = {}

    local 当前区域索引 = self:计算区域索引(x, y)

    -- 判断左边区域
    if x - (当前区域索引 - 1) % 3 * self.区域宽度 < 50 and 当前区域索引 % 3 ~= 1 then
        table.insert(相邻区域, 当前区域索引 - 1)
    end

    -- 判断右边区域
    if (当前区域索引 - 1) % 3 * self.区域宽度 + self.区域宽度 - x < 50 and 当前区域索引 % 3 ~= 0 then
        table.insert(相邻区域, 当前区域索引 + 1)
    end

    -- 判断上边区域
    if y - math.floor((当前区域索引 - 1) / 3) * self.区域高度 < 50 and 当前区域索引 > 3 then
        table.insert(相邻区域, 当前区域索引 - 3)
    end

    -- 判断下边区域
    if math.floor((当前区域索引 - 1) / 3) * self.区域高度 + self.区域高度 - y < 50 and 当前区域索引 <= 6 then
        table.insert(相邻区域, 当前区域索引 + 3)
    end

    -- 判断左上角区域
    if x - (当前区域索引 - 1) % 3 * self.区域宽度 < 50 and
        y - math.floor((当前区域索引 - 1) / 3) * self.区域高度 < 50 and
        当前区域索引 % 3 ~= 1 and 当前区域索引 > 3 then
        table.insert(相邻区域, 当前区域索引 - 4)
    end

    -- 判断右上角区域
    if (当前区域索引 - 1) % 3 * self.区域宽度 + self.区域宽度 - x < 50 and
        y - math.floor((当前区域索引 - 1) / 3) * self.区域高度 < 50 and
        当前区域索引 % 3 ~= 0 and 当前区域索引 > 3 then
        table.insert(相邻区域, 当前区域索引 - 2)
    end

    -- 判断左下角区域
    if x - (当前区域索引 - 1) % 3 * self.区域宽度 < 50 and
        math.floor((当前区域索引 - 1) / 3) * self.区域高度 + self.区域高度 - y < 50 and
        当前区域索引 % 3 ~= 1 and 当前区域索引 <= 6 then
        table.insert(相邻区域, 当前区域索引 + 2)
    end

    -- 判断右下角区域
    if (当前区域索引 - 1) % 3 * self.区域宽度 + self.区域宽度 - x < 50 and
        math.floor((当前区域索引 - 1) / 3) * self.区域高度 + self.区域高度 - y < 50 and
        当前区域索引 % 3 ~= 0 and 当前区域索引 <= 6 then
        table.insert(相邻区域, 当前区域索引 + 4)
    end

    -- 如果都不满足，则添加当前区域
    table.insert(相邻区域, 当前区域索引)

    return 相邻区域
end

return 九宫格
