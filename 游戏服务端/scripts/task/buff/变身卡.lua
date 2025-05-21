local 任务 = {
    名称 = '变身卡',
    --图标 = 1,
    是否BUFF = true
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    if self.时间 <= os.time() then
        self:清除变身(玩家)
    end
end

function 任务:添加任务(玩家)
    local r = 玩家:取任务("变身卡")
    if r then
        r:清除变身(玩家)
    end
    self.时间 = os.time() + 60 * 60 * 12
    self.原形 = 玩家.外形
    self.是否变身 = true
    玩家:添加任务(self)
    玩家:刷新外形()
    return true
end

function 任务:任务战斗开始(对象, 玩家) --对象是战斗对象数据
    if not self.附加 or not 玩家 then
        return
    end

    local 种族差 = 0
    local 总亲和 = 0
    local 重复差 = 0
    local 自身亲和力 = self.亲和力 * 5 or 0
    local bskxz = 1
    if 玩家.是否组队 then
        for _, value in 玩家:遍历队伍() do
            local r = value:取任务("变身卡")
            if r then
                if r.种类 ~= self.种类 then
                    种族差 = 种族差 + 5
                end
                if r.亲和力 then
                    总亲和 = 总亲和 + r.亲和力
                end
                if r.属性id == self.属性id and r.外形 == self.外形 then
                    重复差 = 重复差 + 18
                end
            else
                种族差 = 种族差 + 5
            end
        end
        bskxz = math.floor((214 - 种族差 - 重复差 - math.abs(总亲和 - 自身亲和力) * 2)) * 0.01
        if bskxz < 1 then
            bskxz = 1
        end
    end

    for i, v in ipairs { "金", "木", "水", "火", "土" } do
        对象[v] = (玩家[v] or 0) + self.五行[i]
    end
    if self.附加 then
        for _, v in ipairs(self.附加) do
            local n = math.floor(v[2] * bskxz) * 0.01
            if v[1] == "气血" then
                对象.最大气血 = 对象.最大气血 + math.floor(对象.最大气血 * n)
                对象.气血 = 对象.气血 + math.floor(对象.气血 * n)
            elseif v[1] == "法力" then
                对象.最大魔法 = 对象.最大魔法 + math.floor(对象.最大魔法 * n)
                对象.魔法 = 对象.魔法 + math.floor(对象.魔法 * n)
            elseif v[1] == "速度" then
                if 对象.速度 then
                    对象.速度 = 对象.速度 + math.floor(对象.速度 * n)
                end
            elseif v[1] == "力量" then
                if 对象.攻击 then
                    对象.攻击 = 对象.攻击 + math.floor(对象.攻击 * n)
                end
            elseif v[1] == "物理" then
                if 对象.攻击 then
                    对象.攻击 = 对象.攻击 + n
                end
            else
                对象[v[1]] = 对象[v[1]] and 对象[v[1]] + v[2] or 0 + v[2]
            end
        end
    end
end

function 任务:添加时长(玩家, n)
    self.时间 = self.时间 + n * 60 * 60
end

function 任务:添加任务2(玩家, t)
    local r = 玩家:取任务("变身卡")
    if r then
        if t.外形 == r.外形 and t.属性id == r.属性id and r.是否变身 == (t.属性类型 == 1) then
            r:添加时长(玩家, 6)
            return
        else
            r:清除变身(玩家)
        end
    end
    self.时间 = os.time() + 6 * 60 * 60
    self.原形 = 玩家.外形
    self.是否变身 = t.属性类型 == 1
    self.等级 = t.等级
    self.种类 = t.种类
    self.亲和力 = t.亲和力
    self.五行 = t.五行
    self.附加 = t.附加
    self.外形 = t.外形
    self.图标 = t.皮肤
    self.属性id = t.属性id
    玩家:添加任务(self)
    玩家:刷新外形()
    return true
end

function 任务:清除变身(玩家)
    self:删除()
    玩家:刷新外形()
end

function 任务:任务更新(sec, 玩家)
    --print(self.时间)
    if self.时间 <= sec then
        self:清除变身(玩家)
    end
end

function 任务:任务取详情(玩家)
    return '剩余变身时间: #G' .. tostring((self.时间 - os.time()) // 60)
end

return 任务
