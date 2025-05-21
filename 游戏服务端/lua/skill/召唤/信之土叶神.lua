local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '信之土叶神',
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



function 法术:召唤进入战斗(攻击方,数据,目标,闪现)
    if 数据 then
        目标.目标 = 目标:随机敌方存活目标()
        目标.指令 = "物理"
        目标:置重复操作() 
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return string.format("有几率无需召唤自动加入战斗，提高冰混遗忘抗性#r#R%s%%,进场时立即对随机目标发动一次物理攻击！",self:取效果(攻击方))
end



return 法术
