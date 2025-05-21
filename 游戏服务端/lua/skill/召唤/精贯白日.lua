local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '精贯白日',
    是否被动 = true,
}





function 法术:反震前(攻击方, 挨打方)
    if 攻击方.伤害类型 == '反震' then
        if 攻击方:取技能是否存在('精贯白日') then
            攻击方.魔法伤害 = 攻击方.伤害
        end
    end
end

function 法术:法术取描述()
    return '召唤兽反震时，同时反震气血和法力伤害'
end

return 法术
