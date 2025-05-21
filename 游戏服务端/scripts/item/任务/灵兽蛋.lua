local 物品 = {
    名称 = '灵兽蛋',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    禁止交易 = true,
}
function 物品:初始化()
    if not self.参数 then
        self.参数 = 1
    end
    if not self.种族 then
        self.种族 = 1
    end
    if not self.场次 then
        self.场次 = 0
    end
end

function 物品:使用(玩家)

end

function 物品:道具战斗结束(玩家)
    local 最大场次 = 30
    local 可以孵化最低场次 = 10
    if not self.场次 then
        return
    end
    self.场次 = self.场次 + 1
    if self.场次 > 最大场次 then
        self.场次 = 最大场次
    end
    if math.fmod(self.场次 - 1, 10) == 10 then
        玩家:常规提示("你的“灵兽蛋” 吸纳了妖魔的元气， 似乎有所变化！")
    end
    local jl = false
    if self.场次 > 可以孵化最低场次 and math.random(100) <= 60 then --
        jl = true
    end
    if jl then
        if 玩家:添加坐骑(生成坐骑 { 种族 = self.种族, 几座 = self.参数 }) then
            self:删除()
            玩家:常规提示("你的“灵兽蛋” 吸纳了妖魔的元气， 似乎有所变化！")
        end
    end
end

local _种族 = {
    "人", "魔", "仙", "鬼",



}

function 物品:取描述(玩家)
    if self.参数 and self.种族 and self.场次 then
        return "#Y种族:" .. _种族[self.种族] .. self.参数 .. "坐#r战斗场次:" .. self.场次
    end
end

return 物品
