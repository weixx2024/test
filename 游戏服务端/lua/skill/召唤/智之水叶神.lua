-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-10-24 17:05:25
-- @Last Modified time  : 2024-10-26 14:00:21
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '智之水叶神',
	id = 2113,
}

function 法术:取效果(攻击方)
    -- local qm = 攻击方.亲密 or 0
    -- local dj = 攻击方.等级
    -- local zs = 攻击方.转生
    --2423 + SkillXS(qm,390) + dj * 20 + zs * 100
    return 15
end

function 法术:计算_召唤(P)
    P.抗性.抗封印 = P.抗性.抗封印 + self:取效果(P)
    P.抗性.抗混乱 = P.抗性.抗混乱 + self:取效果(P)
    P.抗性.抗遗忘 = P.抗性.抗遗忘 + self:取效果(P)
end

function 法术:回合开始(攻击方, 挨打方)
    if math.floor(攻击方.最大气血 * 0.3) > 攻击方.气血 then
        local 几率 = self:取几率(攻击方, 挨打方)
        if 几率 > math.random(100) then
            local hp = math.floor(攻击方.最大气血 * 0.5)
            攻击方:增加气血(hp)
        end
    end
end

function 法术:取几率(攻击方, 挨打方)
    local 亲密度 = 攻击方.亲密 or 0
    local 几率 = 10 + math.floor(亲密度 ^ 0.17)
    return 几率
end


function 法术:法术取描述(攻击方, 挨打方)
    return string.format("有几率无需召唤自动加入战斗，提高冰混遗忘抗性%s%%，有%s%%几率自我恢复50%%血量",self:取效果(攻击方),self:取几率(攻击方, 挨打方))
end



return 法术
