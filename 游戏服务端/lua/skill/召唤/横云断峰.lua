-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-07 18:25:22
-- @Last Modified time  : 2022-08-13 06:40:20
local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '横云断峰',
    id = 2315,
}

function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
end

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗 = self:法术取消耗(攻击方)
    if 攻击方:取魔法() < 消耗.消耗MP then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    elseif self.冷却回合 then
        攻击方:提示("#R剩余冷却回合:" .. self.冷却回合)
        return false
    end
    self.xh = 消耗
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh.消耗MP)
        self.xh=false
        self.冷却回合 = 5
        for i,v in ipairs(目标) do
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = 3
            end
        end
    end

end

function 法术:法术取消耗(P)
    local MP = math.floor(P.最大魔法 * 0.7)
    return { 消耗MP = MP}
end

function 法术:法术取目标数()
    return 3
end

function 法术:法术取描述()
    return '对3个单位使用，持续3回合。在持续回合内具有此状态的单位降低药品回复血法和三尸回血量，冷却5回合。 '
end


BUFF = {
    法术 = '横云断峰',
    名称 = '横云断峰',
    id = 106
}
法术.BUFF = BUFF

function BUFF:BUFF加血前(v)
    return math.floor(v*0.5)
end


function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
