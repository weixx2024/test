local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '如虎添翼',
    是否被动 = true,
}

local BUFF

function 法术:进入战斗(攻击方)
    攻击方:添加特效(2151)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.效果=self:法术取BUFF效果(攻击方)
    b.回合 = 2
    local 主人  = 攻击方:取主人()
    if 主人 then
        local a = 主人:进入战斗添加BUFF(BUFF)
        a.效果=self:法术取BUFF效果(主人)
        a.回合 = 2
    end
end



function 法术:召唤进入战斗(攻击方,数据,召唤)

    local b = 召唤:进入添加BUFF(BUFF)
    b.效果=self:法术取BUFF效果(召唤)
    b.回合 = 2
    数据:添加BUFF(901,召唤.位置)

    local a = 攻击方:进入添加BUFF(BUFF)
    a.效果=self:法术取BUFF效果(攻击方)
    a.回合 = 2
    数据:添加BUFF(901,攻击方.位置)
end

function 法术:法术取BUFF效果(挨打方)
    local 效果 = { 抗雷 = 6, 抗火 = 6, 抗水 = 6, 抗风 = 6, 物理吸收 = 6, 抗昏睡 = 5, 抗中毒 = 5,抗混乱 = 5, 抗封印 = 5 }
    for k, v in pairs(效果) do
        挨打方[k] = 挨打方[k] + v
    end
    return 效果
end
function 法术:法术取描述()
    return '进场时为自己和主人添加一个等同于1法1熟练女魔盘的状态，持续两回合。(此技能可以和女魔盘法叠加)'
end


BUFF = {
    法术 = '如虎添翼',
    名称 = '如虎添翼',
    -- id = 901
}

法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        for k, v in pairs(self.效果) do
            单位[k] = 单位[k] - v
        end
    end
end
return 法术
