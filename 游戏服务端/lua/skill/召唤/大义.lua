local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '大义',
    id = 304,
}


function 法术:回合开始(攻击方, 挨打方)
    local 几率 = self:取几率(攻击方, 挨打方)
    if 几率 > math.random(100) then
        local t = 攻击方:取我方魔法低于_百分比(1)
        for _, v in pairs(t) do
            if v.nid  ~= 攻击方.nid then
                local mp = math.floor(v:取魔法() * 0.5)
                v:增加魔法(mp,0,2)
            end
        end
    end
end

function 法术:取几率(攻击方, 挨打方)
    local qm = 攻击方.亲密 or 0
    return math.floor(10 + SkillXS(qm,0.17))
end

function 法术:法术取描述(P)
    local 几率 = self:取几率(P) .. "%"
    return string.format("信誓旦旦，以身护友，回复他人法力。#r#W【技能介绍】#r#G回合开始时有%s几率为己方法量低于30%%的单位恢复50%%法力",几率)
end

return 法术
