-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2023-08-23 23:26:33
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '天降脱兔',
    是否被动 = true,
}

local BUFF
function 法术:物理攻击结束(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) < self:取几率(攻击方) then
            return true
        end
    end
end

function 法术:物理攻击结束附加(攻击方, 挨打方)
    攻击方.伤害 = self:取伤害(攻击方, 挨打方)
    local dst = 挨打方:取附近目标(挨打方.位置)
    table.insert(dst,挨打方)
    local cs = self:取次数(攻击方)
    for i=1,cs do
        for i,v in ipairs(dst) do
            攻击方 = 攻击方:物理_生成对象('物理', v)
            攻击方.禁反震 = true
            攻击方.禁反击 = true
            攻击方.禁保护 = true
            v:被物理攻击(攻击方,v)
            if not v:取BUFF("天降脱兔") then
                local b = v:添加BUFF(BUFF)
                if b then
                    b.回合 = 2
                    b.效果 = self:法术取BUFF效果(v)
                end
            end
        end
    end
    return 法术.名称
end

function 法术:取次数(攻击方)
    local qm = 攻击方.亲密
    local cs = math.random(2,7)
    if qm >= 10000000 then
        cs = math.random(3,7)
    end
    return cs
end


function 法术:取伤害(攻击方, 挨打方)
    local ndcd = math.floor(296.1572 + 0.001 * math.pow(攻击方.攻击, 1.57));
    return math.floor(ndcd)
end

function 法术:取几率(召唤)
    local qm = 召唤.亲密
    return math.floor(45 + SkillXS(qm,0.197))
end

function 法术:法术取描述(召唤)
    return string.format("物理攻击结束后有几率向上飞起后从天而降砸向敌方，对敌方单位造成多次震荡伤害，伤害与自身攻击力相关，受到伤害的目标会进入迟钝状态，此状态下躲闪率降低，持续2回合。")
end

function 法术:法术取BUFF效果(目标)
    local 效果 = { 躲闪率 = 50}
    目标.躲闪率 = 目标.躲闪率 - 50
    return 效果
end

BUFF = {
    法术 = '天降脱兔',
    名称 = '天降脱兔',
    id = 1231
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
        for k, v in pairs(self.效果) do
            单位[k] = 单位[k] + v
        end
        self:删除()
    end
end

function BUFF:BUFF队友伤害(来源)
    return true
end

return 法术
