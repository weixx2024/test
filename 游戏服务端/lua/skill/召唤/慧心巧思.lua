local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '慧心巧思',
    是否被动 = true,
}

function 法术:进入战斗(攻击方)
    self.回合数 = nil
    self.额外生效 = nil
end


function 法术:受到伤害前(攻击方, 挨打方,数据)
    if self.回合数 == nil or 挨打方.战场.回合数 - self.回合数 >= 5 then
        local n = math.floor((挨打方.最大气血 + 挨打方.最大魔法) * 0.7)
        if 攻击方.伤害 > 挨打方.气血 and 攻击方.伤害 > n then
            攻击方.伤害 = 0
            数据:喊话("智慧就是力量")
            self.回合数 = 挨打方.战场.回合数
            self.额外生效 = nil
        end
    elseif self.额外生效 == nil and self:取几率(攻击方) > math.random(100) then
        local n = math.floor((挨打方.最大气血 + 挨打方.最大魔法) * 0.7)
        if 攻击方.伤害 > 挨打方.气血 and 攻击方.伤害 > n then
            攻击方.伤害 = 0
            数据:喊话("智慧就是力量")
            self.回合数 = 挨打方.战场.回合数
            self.额外生效 = true
        end
    end
end

function 法术:取几率(攻击方)
    local qm = 攻击方.亲密 or 0
    local 几率 = 10+math.floor(qm*0.01)
    return 几率
end

function 法术:法术取描述(攻击方, 挨打方)
    return string.format("智慧就是力量。若受到的伤害小于最大气血、法力值之和的一定比例且为致死伤害，则可以免疫这次伤害。每5回合内一定生效1次，有%s%%几率额外再生效1次。",self:取几率(攻击方))
end

return 法术
