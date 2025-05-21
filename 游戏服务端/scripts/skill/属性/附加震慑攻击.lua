local 法术 = {
    类别 = '属性',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '附加震慑攻击',
    id = 1204,
    是否物理法术 = true,
}

function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        攻击方.伤害 = self:取伤害(攻击方, 挨打方)
        挨打方:被法术攻击(攻击方, self)
        return true
    end
end

function 法术:是否触发(攻击方, 挨打方)
    if math.random(100) <= 攻击方.附加震慑攻击 then
        return true
    end
end

function 法术:取伤害(攻击方, 挨打方)
    local 震慑 = self:取HP伤害()
    local 扣蓝 = self:取MP伤害()
    扣蓝 = math.floor(扣蓝 * 0.01 * 挨打方.魔法)
    震慑 = (震慑 - 挨打方.抗震慑 + 攻击方.忽视抗震慑) * (1 + 攻击方.加强震慑
        * 0.01)
    震慑 = 取震慑强克系数(攻击方, 挨打方, 震慑)
    if 震慑 > 55 then
        震慑 = 55
    end
    挨打方:减少魔法(扣蓝)
    local n = math.floor(震慑 * 0.01 * 挨打方.气血)
    if n < 1 then
        n = 1
    end
    return n
end

function 法术:取HP伤害()
    local n = math.floor((15 + 1 ^ 0.3255) * 100) * 0.01
    if n > 42 then
        n = 42
    end
    return n
end

function 法术:取MP伤害()
    local n = math.floor((15 + 1 ^ 0.352) * 100) * 0.01
    if n > 50 then
        n = 50
    end
    return n
end

return 法术
