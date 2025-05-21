local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '审时度势',
	是否终极 = true,
    id = 2138,
}


local BUFF
function 法术:进入战斗(攻击方)
    --战场BUF
end

function 法术:回合开始(攻击方,数据)
    if not 攻击方:取BUFF('隐身') and 攻击方.气血/攻击方.最大气血 <= 0.3 and math.random(100) <= 25 then
        local b = 攻击方:添加BUFF(BUFF)
        if b then
            b.回合 = 3
            b.回合数 = 0
            攻击方.是否隐身 = true
        end
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "当召唤兽自身血量低于一定值时，下回合开始有几率被动触发隐身状态，持续为3回合。"
end

BUFF = {
    法术 = '隐身',
    名称 = '隐身',
    id = '隐身'
}

法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.是否隐身 = false
    end
end

return 法术
