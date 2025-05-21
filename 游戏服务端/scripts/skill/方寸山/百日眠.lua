local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '百日眠',
    id = 205
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local 几率 = self:法术取几率(攻击方, v)
        local 成功 = 几率 >= 100 and true or math.random(100) <= 几率
        if 成功 then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = self:法术取回合()
                b.挣脱率 = 100 - 几率
            end
        end
    end
    if 攻击方.是否玩家 then
        self.熟练度 = self.熟练度 < self.熟练度上限 and self.熟练度 + 1 or self.熟练度上限
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
end

function 法术:法术基础几率()
    return 86 + 3.6 * self.熟练度 ^ 0.3
end

function 法术:法术取几率(攻击方, 挨打方)
    local 几率 = self:法术基础几率()
    几率 = 取人法几率('昏睡', 几率, 攻击方, 挨打方)
    return 几率
end

function 法术:法术取回合()
    if self.熟练度 >= 12000 then
        return 7
    elseif self.熟练度 >= 9600 then
        return 6
    elseif self.熟练度 >= 5800 then
        return 5
    elseif self.熟练度 >= 2300 then
        return 4
    else
        return 3
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.721) }
end

function 法术:取目标数()
    if self.熟练度 >= 11864 then
        return 7
    elseif self.熟练度 >= 5215 then
        return 6
    elseif self.熟练度 >= 1638 then
        return 5
    elseif self.熟练度 >= 226 then
        return 4
    else
        return 3
    end
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    return string.format('可以造成对手#R%s#G人昏睡无法行动#R%s#G个回合。',
        self:取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '百日眠',
    名称 = '昏睡',
    id = 201
}
法术.BUFF = BUFF
function BUFF:BUFF回合开始() --挣脱
    -- if math.random(100) < self.挣脱率 then
    --     self:删除()
    -- end
end

local _可执行 = {
    道具 = true,
    召唤 = true,

}


function BUFF:BUFF指令开始(对象) --昏睡
    if not _可执行[对象.指令] then
        return false
    end
end
--
function BUFF:BUFF被物理攻击后(攻击方, 挨打方)
    if 挨打方 then
        if not 挨打方.是否死亡 then
            挨打方.重新行动 = true
        end
        self:删除()
        -- if 攻击方.速度 <= 挨打方.速度 and not 挨打方.是否死亡 and not 挨打方.已经出手 then
        --     挨打方.战场.解睡单位 = 挨打方.位置
        -- end
    end
end

function BUFF:BUFF被法术攻击后(攻击方, 挨打方)
    if not 挨打方.是否死亡 then
        挨打方.重新行动 = true
    end
    self:删除()
    -- if 攻击方.速度 <= 挨打方.速度 and not 挨打方.是否死亡 and not 挨打方.已经出手 then
    --     挨打方.战场.解睡单位 = 挨打方.位置
    -- end
end

function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('混乱')
        -- 目标:删除BUFF('中毒')
        目标:删除BUFF('遗忘')
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    elseif math.random(100) < self.挣脱率 then
        self:删除()
    end
end

return 法术
