-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-07 18:25:22
-- @Last Modified time  : 2022-08-13 06:40:20
local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '步步生莲',
    id = 2102,
}

local BUFF

function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
end

function 法术:回合开始()
    if self.冷却回合 then
        self.冷却回合 = self.冷却回合 - 1
        if self.冷却回合 <= 0 then
            self.冷却回合 = nil
        end
    end
end

function 法术:法术施放前(攻击方, 目标)
    self.偷取 = {}
end

function 法术:法术施放(攻击方, 目标)
    local 消耗 = self:法术取消耗(攻击方)
    if 攻击方:取魔法() < 消耗.消耗MP then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    elseif not 攻击方.是否PK then
        攻击方:提示("#RPVE可用！")
        return false
    end
    if self.冷却回合 then
        攻击方:提示("#R剩余冷却回合:" .. self.冷却回合)
        return false
    end
    self.xh = 消耗
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        for _, v in ipairs(目标) do
            self.偷取[1] = math.floor((self.偷取[1] or 0) + v.最大气血*_*0.05)
            self.偷取[2] = math.floor((self.偷取[2] or 0) + v.最大魔法*_*0.05)
            v:减少魔法(self.偷取[2])
            攻击方.伤害 = math.floor(v.最大气血*_*0.05)
            v:被法术攻击(攻击方,self)
        end
        local 主人 = 攻击方:取主人()
        if 主人 and self:取几率(攻击方) > math.random(100) then
            if self.偷取[1] then
                主人:增加气血(self.偷取[1]) 
            end
            if self.偷取[2] then
                主人:增加魔法(self.偷取[2],0,"特殊加") 
            end
        end
        self.偷取 = {}
        攻击方:减少魔法(self.xh.消耗MP)
        self.xh=false
        self.冷却回合 = 5
    end
end


function 法术:取几率(P)
    return 100
end

function 法术:法术取目标数()
    return 3
end

function 法术:法术取消耗(P)
    local MP = math.floor(P.最大魔法 * 0.7)
    return { 消耗MP = MP }
end

function 法术:法术取描述()
    return '对3个单位使用，偷取第一个目标最大气血和法量的5%，依次递增(10%，15%)，并将偷取的血法按照一定百分比回复主人，冷却5回合(主动PVP)'
end

return 法术
