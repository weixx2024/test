-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-10-13 16:15:07
-- @Last Modified time  : 2024-10-15 20:16:05
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '柳暗花明',
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
    return string.format("本方每有1个召唤兽被杀死，本次战斗中提升自己1%%的冰混睡忘抗性。 ，最多提升10%%冰混睡忘抗性。（战斗结束后消失）")
end


BUFF = {
    法术 = '柳暗花明',
    名称 = '柳暗花明',
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
    if self.增加次数 < 10 then
        self.增加次数 = self.增加次数 + 1
        local 效果 = { 抗封印 = 1, 抗混乱 = 1, 抗遗忘 = 1}
        for k, v in pairs(效果) do
            攻击方.抗性[k] = 攻击方.抗性[k] + v
        end
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        local 效果 = { 抗封印 = 1, 抗混乱 = 1, 抗遗忘 = 1}
        for k, v in pairs(效果) do
            攻击方.抗性[k] = 攻击方.抗性[k] - v*self.增加次数
        end
        self:删除()
    end
end

return 法术
