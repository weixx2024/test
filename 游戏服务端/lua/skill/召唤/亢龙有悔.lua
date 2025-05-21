local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '亢龙有悔',
    是否被动 = true,
}

function 法术:回合开始(攻击方, 挨打方)
    self.目标组 = {}
end

function 法术:物理攻击(攻击方, 挨打方)
    self.目标组 = self.目标组 or {}
    if 挨打方 then
        攻击方.禁反震 = true
        攻击方.禁反击 = true
        攻击方.禁保护 = true
        if self.目标组[挨打方.位置] then
            攻击方.伤害 = 攻击方.伤害 * (100-self.目标组[挨打方.位置])/100
            self.目标组[挨打方.位置] = self.目标组[挨打方.位置]  + 20
        else
            self.目标组[挨打方.位置] = 20
        end
    end
end

function 法术:连击开始前(攻击方,挨打方,数据,伤害)
    return true
end

function 法术:法术取描述(攻击方, 挨打方)
    return "连击形式不再是对同一目标连续攻击多次，而是以X%伤害随机攻击敌人N次，无视反击和保护，对不同目标伤害不递减，对已攻击过的目标每次伤害递减为上次的X%。"
end

return 法术
