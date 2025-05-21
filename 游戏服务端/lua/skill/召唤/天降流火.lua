local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '天降流火',
    是否被动 = true,
}

function 法术:回合开始(攻击方, 挨打方)
    攻击方.天降流火次数 = 0
end

local BUFF
function 法术:天降流火计算(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) < self:取几率(攻击方) and 攻击方.天降流火次数 < 9 then
            self.狂暴几率 = 100
            self.致命几率 = 100
            self.命中率 = 100
            攻击方.狂暴几率 = 攻击方.狂暴几率 + self.狂暴几率
            攻击方.致命几率 = 攻击方.致命几率 + self.致命几率
            攻击方.命中率 = 攻击方.命中率 + self.命中率
            攻击方 = 攻击方:物理_生成对象('物理', 挨打方)
            攻击方.禁反震 = true
            攻击方.禁反击 = true
            攻击方.禁保护 = true
            攻击方.天降流火次数 = 攻击方.天降流火次数 + 1
            return true
        end
    end
end

function 法术:物理攻击后(攻击方, 挨打方)
    if self.狂暴几率 then
        攻击方.狂暴几率 = 攻击方.狂暴几率 - self.狂暴几率
        攻击方.致命几率 = 攻击方.致命几率 - self.致命几率
        攻击方.命中率 = 攻击方.命中率 - self.命中率
        self.狂暴几率 = nil
        self.致命几率 = nil
        self.命中率 = nil
    end
end

function 法术:天降流火附加(攻击方, 挨打方)
    local dst = 挨打方:取附近目标(挨打方.位置)
    local 伤害 = 攻击方.伤害
    for i, v in ipairs(dst) do
        攻击方.当前数据:群体目标添加特效(1238, v.位置)
        v:减少气血(伤害 * 1.25)

        -- 攻击方.伤害 = 伤害*0.25
        -- 攻击方.躲避 = false
        -- 攻击方.禁反震 = true
        -- 攻击方.禁反击 = true
        -- 攻击方.禁保护 = true
        -- v:被物理攻击(攻击方,v)
    end
end

function 法术:取伤害(攻击方, 挨打方)
    local ndcd = math.floor(296.1572 + 0.00023 * math.pow(攻击方.最大魔法, 1.57));
    return math.floor(ndcd)
end

function 法术:取几率(召唤)
    local qm = 召唤.亲密
    return math.floor(300 + SkillXS(qm, 0.43))
end

-- function 法术:法术取描述(召唤)
--     return string.format("物理攻击敌方时有几率触发射箭攻击，触发时命中率提升20%，致命率和狂暴率提升10%。如果射箭攻击致死目标，则将致死一箭伤害的25%溅射给目标周围的其他敌方单位。每回合至多触发2次射箭攻击。。")
-- end

return 法术
