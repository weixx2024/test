local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '顺水推舟',
	是否终极 = true,
    id = 2138,
}


local BUFF
function 法术:物理攻击后(攻击方, 挨打方 ,数据,伤害)
    if 挨打方 and 攻击方.触发连击 == nil then
        local 几率 = self:取几率(攻击方, 挨打方)
        if 几率 > math.random(100) and not 挨打方:取BUFF('顺水推舟') then
            local b = 挨打方:添加BUFF(BUFF)
            if b then
                b.回合 = 3
                b.效果 = self:法术取BUFF效果(攻击方, 挨打方)
            end
        end
    end
end

function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 属性范围 = {'攻击', '速度'}
    local 效果 = {}
    local 最高 = "攻击"
    for k, v in pairs(属性范围) do
        if 挨打方[最高] <= 挨打方[v] then
            最高 = v
        end
    end
    if 最高 == "速度" then
        挨打方[最高] = 挨打方[最高] - math.floor(挨打方[最高]*0.05)
        效果[最高] = math.floor(挨打方[最高]*0.05)
    else
        挨打方[最高] = 挨打方[最高] - math.floor(挨打方[最高]*0.1)
        效果[最高] = math.floor(挨打方[最高]*0.1)
    end
    return 效果
end

function 法术:取几率(攻击方)
    local qm = 攻击方.亲密 or 0
    local 几率 = 40 + SkillXS(qm,0.5)
    return 几率
end

function 法术:法术取描述(攻击方, 挨打方)
    return "物理攻击敌方时，有一定几率触发顺水推舟效果，中此状态的单位在未来3回合内最高属性值将降低10%。（若最高值为速度，所受到的减益效果将*50%） "
end

BUFF = {
    法术 = '顺水推舟',
    名称 = '顺水推舟',
    id = 2138
}
法术.BUFF = BUFF

function BUFF:BUFF死亡处理(攻击方, 挨打方)

end


function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        for i,v in pairs(self.效果) do
            单位[i] = 单位[i] + v
        end
        self:删除()
    end
end

return 法术
