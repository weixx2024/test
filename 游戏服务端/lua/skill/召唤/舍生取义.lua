local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '舍生取义',
    id = 2121,
}

local BUFF
function 法术:进入战斗(攻击方, 目标)
    self.冷却回合 = nil
end

function 法术:法术施放(攻击方, 目标)
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        if self:取几率(攻击方) >= math.random(100) then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = 3
            end
        end
    end
end

function 法术:法术施放后(攻击方, 目标)
    攻击方:减少气血(攻击方.最大气血)
end

function 法术:法术取回合()
    return 3
end

function 法术:法术取目标数()
    return 1
end

function 法术:回合开始()

end

function 法术:法术取消耗()
    return { 消耗MP = 3600 }
end

function 法术:取几率(P)
    local qm = P.亲密 or 0
    return 5+math.floor(qm^0.252)
end

function 法术:法术取描述(P)

    return string.format('牺牲自己，有%s几率使一个目标只能进行物理攻击，持续两回合。',self:取几率(P).."%")
end

BUFF = {
    法术 = '舍生取义',
    名称 = '舍生取义',
    id = 2650
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)

end

function BUFF:BUFF添加前(buff, 目标)
    if self == buff then
        目标:删除BUFF('舍生取义')
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function BUFF:BUFF指令开始(目标) --混乱
    if 目标.目标 and 目标:是否我方(目标.目标) then
        local r = 目标:随机敌方存活目标()
        目标:置指令('物理', r)
    elseif 目标.指令 ~= "物理" then
        local r = 目标:随机敌方存活目标()
        目标:置指令('物理', r)
    end
end


function BUFF:BUFF法术施放前(攻击方, 挨打方)

    return false

end

function BUFF:BUFF物品使用前(攻击方, 挨打方)

    return false

end

return 法术
