
local 任务 = {
    名称 = '杀人香',
    类型 = '其它'
}

function 任务:任务初始化(玩家, ...)
    self.时间 = os.time() + 60 * 60
end

function 任务:任务上线(玩家)
    self:删除()
end

local _牢房坐标 = {
    { 27, 75 },
    { 39, 74 },
    { 46, 70 },
    { 53, 61 },
    { 64, 59 },
    { 73, 57 },
    { 55, 82 },
    { 66, 80 },
    { 71, 76 },
    { 89, 70 },
    { 100, 64 },
    { 107, 60 },
    { 108, 44 },
    { 90, 37 },
    { 80, 34 },
    { 75, 30 },
    { 115, 31 },
    { 106, 24 },
    { 88, 20 },
    { 79, 14 },
    { 69, 10 },
    { 113, 10 },
    { 121, 15 },
    { 28, 45 },

}
function 任务:任务更新(玩家, sec)
    if self.时间 < os.time() then
        self:删除()
    end
end

function 任务:任务战斗结束(玩家, 胜负, 类型)
    if 类型 == 5 and 胜负 then
        local n = math.random(#_牢房坐标)
        玩家:切换地图(1126, _牢房坐标[n][1], _牢房坐标[n][2])
        self:删除()
        for i, P in 玩家:遍历队伍() do
            local r = 生成任务 { 名称 = '坐牢' }
            if r then
                P:添加任务(r)
            end
        end
    end
end

function 任务:任务取详情(玩家)
    return '#Y剩余时间 #G' .. tostring((self.时间 - os.time()) // 60) .. "分钟"
end

return 任务
