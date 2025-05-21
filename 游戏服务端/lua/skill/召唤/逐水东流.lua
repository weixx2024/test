-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2022-09-01 11:50:58

local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '逐水东流',
    id = 2102,


}
function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
    self.待机回合 = nil
end

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方.是否怪物 then
        消耗mp = 0
    end
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    if not 攻击方:是否PK() then
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
        for _, v in ipairs(目标) do
            if v.水>= 50 then
                if self:取几率(攻击方, v) > math.random(100) then
                    v:被驱逐(2118, 攻击方.当前数据)
                    self.待机回合 = 2
                end
            end
        end
        self.冷却回合 = 5
    end
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = 210 }
end

function 法术:取几率(攻击方, 挨打方)
    local qm = 攻击方.亲密 or 0
    return math.floor(25 + SkillXS(qm,0.05))
end

function 法术:回合开始()
    if self.冷却回合 then
        self.冷却回合 = self.冷却回合 - 1
        if self.冷却回合 <= 0 then
            self.冷却回合 = nil
        end
    end
    if self.待机回合 then
        self.待机回合 = self.待机回合 - 1
        if self.待机回合 <= 0 then
            self.待机回合 = nil
        end
    end
end

function 法术:BUFF指令开始()
    if self.待机回合 then
        return false
    end
end

--这技能 是玩家之间的 么      应该是打架用的技能
function 法术:法术取描述()
    return '有少量几率直接将五行大于等于水50的召唤兽驱离出场，成功使用后召唤兽下回合待机，冷却5回合。（主动）'
end

return 法术
