local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '福禄双全',
	是否终极 = true,
    id = 2138,
}


local BUFF
function 法术:进入战斗(攻击方)
    local b = 攻击方:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

function 法术:召唤进入战斗(攻击方,数据,召唤)
    local b = 召唤:进入添加BUFF(BUFF)
    if b then
        b.回合 = 150
        数据:添加BUFF(2138,召唤.位置)
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "本方每有1个召唤兽被杀死，本次战斗中提升自己2%%仙法、鬼火抗性，最多提升20%%仙法鬼火抗性。 （战斗结束后消失） "
end

BUFF = {
    法术 = '福禄双全',
    名称 = '福禄双全',
    id = 2138
}
法术.BUFF = BUFF

function BUFF:BUFF添加后(buff, 目标)
    self.增加次数 = 0
    if buff == self then
        
    end
end


function BUFF:添加属性(攻击方)
    self.增加次数 = self.增加次数 or 0
    if self.增加次数 < 20 then
        self.增加次数 = self.增加次数 + 1
        local 效果 = { 抗雷 = 2, 抗火 = 2, 抗水 = 2, 抗风 = 2, 抗鬼火 = 2}
        for k, v in pairs(效果) do
            攻击方.抗性[k] = 攻击方.抗性[k] + v
        end
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        local 效果 = { 抗雷 = 2, 抗火 = 2, 抗水 = 2, 抗风 = 2, 抗鬼火 = 2}
        for k, v in pairs(效果) do
            攻击方.抗性[k] = 攻击方.抗性[k] - v*self.增加次数
        end
        self:删除()
    end
end

return 法术
