local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '暗影离魂',
}

local BUFF
function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

function 法术:召唤进入战斗(攻击方,数据,召唤)
    local b = 召唤:进入添加BUFF(BUFF)
    b.回合 = 150
end

function 法术:法术取目标数(攻击方)
    local qm = 攻击方.亲密 or 0
    local sl = 2
    if math.random(100) < self:取几率(攻击方) then
        sl = sl + 1
    end
    return sl
end

function 法术:取几率(攻击方)
    local qm = 攻击方.亲密 or 0
    return 20 + SkillXS(qm, 0.7)
end

function 法术:物理攻击(攻击方, 挨打方, 数据, n)
    if n and n ~= 1 then
        local qm = 攻击方.qm or 0
        local xs = 1
        if n ~= 1 then
            xs = 0.65
        end
        攻击方.伤害 = math.floor(攻击方.伤害*xs)
    end
end

function 法术:法术取描述(P)
    return string.format("每3回合获得魂影攻击效果，物理攻击时同时从本体分化出若干个魂影进行攻击，有%s几率额外增加一个魂影", self:取几率(P))
end

BUFF = {
    法术 = '暗影离魂',
    名称 = '暗影离魂',
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        self.当前回合 = nil
    end
end

function BUFF:BUFF回合开始() --挣脱

end

function BUFF:BUFF指令开始(目标) --暗影
    if 目标.指令 == "物理" then
        if 目标.目标 == nil then
            目标.目标 = 目标:随机敌方存活目标()
        end
        local v = 目标.战场:取对象(目标.目标)
        if v and not 目标:是否我方(v) then
            if self.当前回合 == nil or self.当前回合 + 3 == 目标.战场.回合数 then
                目标:置指令('暗影离魂', 目标.目标,nil,"暗影离魂")
                self.当前回合 = 目标.战场.回合数
            end
        end
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function BUFF:BUFF队友伤害(来源)

end



return 法术
