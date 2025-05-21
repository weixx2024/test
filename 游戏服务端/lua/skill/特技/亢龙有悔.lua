local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '亢龙有悔',
    种族 = 2 --天界
}

function 法术:回合开始(攻击方, 挨打方)
    self.目标组 = {}
end

function 法术:取是否连击(攻击方, 挨打方)
    self.目标组 = self.目标组 or {}
        if 挨打方 then
            local jl = self:取机率(攻击方)
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

return 法术