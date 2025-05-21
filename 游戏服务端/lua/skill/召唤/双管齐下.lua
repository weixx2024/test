local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '双管齐下',
}


local BUFF
function 法术:进入战斗(攻击方)
    self.已添加 = false
    --战场BUF
end
function 法术:战斗开始(攻击方,数据)
    if not self.已添加  then --and 攻击方:是否PK()
        self.已添加 = true
        for k, v in 攻击方:遍历敌方玩家() do
            local b = v:添加BUFF(BUFF)
            b.回合 = 150
            数据:添加BUFF(BUFF.名称,v.位置)
        end
        for k, v in 攻击方:遍历我方玩家() do
            local b = v:添加BUFF(BUFF)
            b.回合 = 150
            数据:添加BUFF(BUFF.名称,v.位置)
        end
        
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "场上所有人物施法前必须付出一定血量的代价，若不够则人物将无法施法，此技能每回合只生效一次。"
end

BUFF = {
    法术 = '双管齐下',
    名称 = '双管齐下',
    --  id = 401
}
法术.BUFF = BUFF


function BUFF:BUFF法术施放前(攻击方, 挨打方,法术,数据)--挣脱
    if 攻击方.双管齐下 == nil or 攻击方.双管齐下 ~= 攻击方.战场.回合数 then
        攻击方.双管齐下 = 攻击方.战场.回合数
        local 扣血 = math.floor(攻击方.最大气血*0.1)
        if 攻击方.气血 <= 扣血 then
            return false
        end
        local 目标数据 = 攻击方.战场:指令开始()
        攻击方:减少气血(扣血)
        攻击方.战场:指令结束()
        数据:法术后(目标数据)
    end
end

function BUFF:BUFF死亡处理(攻击方, 挨打方)

end


function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
