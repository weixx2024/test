-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-09-20 18:40:16
-- @Last Modified time  : 2024-09-20 20:00:24

local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '百草竞发',
    是否被动 = true,
}

local BUFF
local BUFF1
local DBUFF


function 法术:物理攻击后(攻击方, 挨打方 ,数据,伤害)
    if 挨打方 and 攻击方.触发连击 == nil then
        local 几率 = self:取几率(攻击方, 挨打方)
        if 几率 > math.random(100) then
            local b = 挨打方:添加BUFF(DBUFF)
            self.BUFF目标组 = {目标={}}
            if b then
                b.回合 = 1
                self.BUFF目标组.目标={挨打方}
            end
            local 目标数 = self:法术取目标数(攻击方)
            local dst = 攻击方:所满足对象(
                function(v)
                    if (not v.是否死亡 or (攻击方:是否我方(v) and v.是否玩家)) and v.位置 ~= 攻击方.位置 and v.位置 ~= 挨打方.位置 and not v:取BUFF('百草竞发') then
                        return true
                    end
                end
            )
            for i,v in ipairs(dst) do
                if i < 目标数 then
                    local b
                    if 攻击方:是否我方(v) then
                        b = v:添加BUFF(BUFF)
                        v.当前数据.位置 = v.位置
                    else
                        b = v:添加BUFF(DBUFF)
                    end
                    if b then
                        b.回合 = 1
                        self.BUFF目标组.目标[#self.BUFF目标组.目标+1] = v
                    end
                end
            end
        end
        -- return true
    end
end

function 法术:法术施放后(攻击方, 挨打方)
    if 挨打方 then
        self.BUFF目标组 = {目标={}}
        local 成功 = false
        for i,v in ipairs(挨打方) do
            local 几率 = self:取几率(攻击方, v)
            if 几率 > math.random(100) then
                成功 = true
                local b = v:添加BUFF(DBUFF)
                if b then
                    b.回合 = 1
                    self.BUFF目标组.目标[#self.BUFF目标组.目标+1]=v
                end
            end
        end
        if 成功 then
            local 目标数 = self:法术取目标数(攻击方)
            local function 取是否挨打(挨打方,目标)
                for i,v in ipairs(挨打方) do
                    if v.位置 == 目标.位置 then
                        return true
                    end
                end
                return false
            end
            local dst = 攻击方:所满足对象(
                function(v)
                    if (not v.是否死亡 or (攻击方:是否我方(v) and v.是否玩家)) and v.位置 ~= 攻击方.位置 and not 取是否挨打(挨打方,v) and not v:取BUFF('百草竞发') then
                        return true
                    end
                end
            )
            for i,v in ipairs(dst) do
                if i < 目标数 then
                    local b
                    if 攻击方:是否我方(v) then
                        b = v:添加BUFF(BUFF)
                    else
                        b = v:添加BUFF(DBUFF)
                    end
                    if b then
                        b.回合 = 1
                        self.BUFF目标组.目标[#self.BUFF目标组.目标+1] = v
                    end
                end
            end
        end
        return true
    end
end

function 法术:法术取目标数(攻击方)
    return math.random(3,7)
end

function 法术:取几率(攻击方)
    local qm = 攻击方.亲密 or 0
    local 几率 = 40 + SkillXS(qm,0.5)
    return 几率
end

function 法术:法术取描述(P)
    local str = self:取几率(P) .. "%"
    return string.format("主动攻击敌方或者施放风法时有%s几率生长百草，随机缠绕场上多个目标，若缠绕己方目标则为其回复血法，若缠绕敌方目标则对其造成一次风雷涌动伤害。去疾长大后对敌方造成风法伤害时会额外增加伤害。",str)
end

function 法术:法术取BUFF1效果(目标)
    local 效果 = { 加强风 = 50}
    目标.抗性.加强风 = 目标.抗性.加强风 + 50
    return 效果
end

function 法术:战斗指令开始(目标,数据)
    self.BUFF组 = {}
    if (目标.指令 == "物理" or 目标.指令 == "群体物理" or 目标.指令 == "法术") and 目标.外形 ~= 601001 then
        local 目标数据 = 目标.战场:指令开始()
        目标.外形 = 601001
        local b = 目标:添加BUFF(BUFF1)
        if b then
            b.回合 = 155
            b.效果 = self:法术取BUFF1效果(目标)
        end
        数据:切换外形(601001,目标.位置,目标数据)
        目标.战场:指令结束()
    end
end

function 法术:战斗指令结束后(攻击方,数据)
    if self.BUFF目标组 and #self.BUFF目标组.目标 > 0 then
        local 目标数据 = 攻击方.战场:指令开始()
        for i,v in ipairs(self.BUFF目标组.目标) do
            if 攻击方:是否我方(v) and not v.是否死亡 then
                local hp,mp = self:法术取恢复(攻击方,v)
                v:增加气血(hp)
                v:增加魔法(mp,2)
                v:删除BUFF("百草竞发回",v.位置)
            else
                攻击方.伤害 = self:法术取伤害(攻击方, v)
                v.伤害类型 = "狂暴"
                v:被法术攻击(攻击方,self)
                v:删除BUFF("百草竞发伤")
            end
        end
        攻击方.战场:指令结束()
        数据:法术(704, 目标数据)
        self.BUFF目标组 = nil
    end
end

function 法术:法术取恢复(攻击方,挨打方)
    return math.floor(攻击方.最大气血*0.1),math.floor(攻击方.最大魔法*0.1)
end

function 法术:法术基础伤害(攻击方)
    local 等级 = 攻击方.等级 + 1
    local 伤害 = 等级 * (64.98918 + 2.03423 * self.熟练度 ^ 0.4)
    return math.floor(伤害)
end


function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = self:法术基础伤害(攻击方)
    伤害 = 取仙法伤害('风', 伤害, 攻击方, 挨打方)
    return math.floor(伤害)
end

BUFF1 = {
    法术 = '百草变身',
    名称 = '百草变身',
    -- id = 2925
}

function BUFF1:BUFF添加后(buff, 目标)
    if self == buff then

    end
end

function BUFF1:BUFF添加前(buff, 目标)

end

function BUFF1:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        for k, v in pairs(self.效果) do
            单位.抗性[k] = 单位.抗性[k] - v
        end
        self:删除()
    end
end

DBUFF = {
    法术 = '百草竞发伤',
    名称 = '百草竞发伤',
    id = 1241
}

function DBUFF:BUFF添加后(buff, 目标)
    if self == buff then

    end
end

function DBUFF:BUFF回合开始() --挣脱

end

function DBUFF:BUFF指令开始(目标) --混乱

end

function DBUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function DBUFF:BUFF队友伤害(来源)
    return true
end



BUFF = {
    法术 = '百草竞发回',
    名称 = '百草竞发回',
    id = 1243
}

法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then

    end
end

function BUFF:BUFF回合开始() --挣脱

end

function BUFF:BUFF指令开始(目标) --混乱

end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function BUFF:BUFF队友伤害(来源)
    return true
end

return 法术
