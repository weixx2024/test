local 法术 = {
    类别 = '召唤',
    类型 = 0,
    对象 = 1,
    条件 = 37,
    名称 = '明察秋毫',
	是否终极 = true,
    id = 2137,
}

local BUFF
function 法术:战斗开始(攻击方)
    if 攻击方:是否PK() then -- 这是被动 
        for k, v in 攻击方:遍历敌方() do
            local b = v:添加BUFF(BUFF)
            b.回合 = 2
            b.攻击方 = 攻击方
        end
    end
end

function 法术:法术取描述(P)
    return string.format("使敌方所有人物与召唤兽的血量及法量可见")
end


BUFF = {
    法术 = '明察秋毫',
    名称 = '明察秋毫',
    id = 2137
}

法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        -- self:删除()
    end

end

function BUFF:BUFF回合开始() --挣脱

end

function BUFF:BUFF指令开始(目标) --混乱

end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 or self.攻击方 == nil or (self.攻击方.是否死亡 and self.攻击方.是否消失) then
        self:删除()
    end
end


return 法术
