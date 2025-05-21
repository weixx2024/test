-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2022-09-01 11:50:58
local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '朝云暮雨',
    id = 2105,


}

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方.是否怪物 then
        消耗mp = 0
    end
    if 攻击方:取魔法() < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        攻击方.伤害 = self:法术取伤害(攻击方, v)
        v:被法术攻击(攻击方, self)
    end

end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = 1280 }
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = 0
    local 等级 = 攻击方.等级 + 1
    伤害 = 等级 * (49.994 + 1.44271 * 攻击方.最大魔法 ^ 0.4)
    伤害 = 强克伤害加成(攻击方, 挨打方, 伤害)
    伤害 = 伤害 * (100 - (攻击方.伤害衰减 or 1) * 10) * 0.01
    local n = 攻击方:取我方指定模型单位(攻击方.外形,攻击方.位置)
    if n ~= 0 then
        伤害 = 伤害 * 2
    end
    if 伤害 <= 0 then
        伤害 = 1
    end
    return math.floor(伤害)
end

function 法术:法术取描述()
    return '对敌方造成伤害，目标一人，如果己方有与自己造型相同的召唤兽在场，则伤害加倍'
end

return 法术
