local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '子虚乌有',
    id = 2101,
}

local BUFF
function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
end

function 法术:法术施放(攻击方, 目标, 战场)
    local 消耗mp = self:法术取消耗(攻击方).消耗MP
    if 攻击方.是否怪物 then
        消耗mp = 12600
    end
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    if self.冷却回合 then
        攻击方:提示("#R剩余冷却回合:" .. self.冷却回合)
        return false
    end
    self.xh = 消耗mp
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
        self.冷却回合 = 5
        if 目标[1] and 目标[1].位置 == 攻击方.位置 then
            local dst = 攻击方:所满足对象(
                function(v)
                    if not v.是否死亡 and 攻击方:是否我方(v) and v.位置 ~= 攻击方.位置 then
                        return true
                    end
                end
            )
            if #dst > 0 then
                目标[1] = dst[math.random(1,#dst)]
            end
        end
        for _, v in ipairs(目标) do
            local b = v:添加BUFF(BUFF)
            b.回合 = 3
            -- 数据:添加BUFF("隐身",v.位置)
            v.是否隐身 = true
        end
        local b = 攻击方:添加BUFF(BUFF)
        b.回合 = 3
        -- 数据:添加BUFF("隐身",攻击方.位置)
        攻击方.是否隐身 = true
    end
end

function 法术:法术取目标数()
    return 1
end

function 法术:回合开始()
    if self.冷却回合 then
        self.冷却回合 = self.冷却回合 - 1
        if self.冷却回合 <= 0 then
            self.冷却回合 = nil
        end
    end
end

function 法术:法术取消耗(攻击方)
    return { 消耗MP = 12 }
end

function 法术:法术取描述()
    return '#W自己与己方任一单位同时隐身，持续3回合，冷却时间5回合。'
end

BUFF = {
    法术 = '隐身',
    名称 = '隐身',
    id = '隐身'
}

法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.是否隐身 = false
    end
end

function BUFF:BUFF添加前()
    return true
end

return 法术
