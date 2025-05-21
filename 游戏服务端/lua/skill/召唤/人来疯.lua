local 法术 = {
    类别 = '召唤',
    类型 = 2,
    条件 = 1,
    对象 = 0,
    名称 = '人来疯',
	是否终极 = true,
    id = 2138,
}


local BUFF
function 法术:进入战斗(攻击方)
    self.已添加 = false
    --战场BUF
end
function 法术:回合开始(攻击方,数据)
    if not self.已添加 and 攻击方:是否PK() then --
        self.已添加 = true
        for k, v in 攻击方:遍历敌方玩家() do
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = 150
                数据:添加BUFF(BUFF.名称,v.位置)
            end
        end
    end
end

function 法术:法术取描述(攻击方, 挨打方)
    return "有几率对有新召唤兽上场的敌方人物造成伤害  "
end

BUFF = {
    法术 = '人来疯',
    名称 = '人来疯',
    -- id = 2138
}
法术.BUFF = BUFF


function BUFF:BUFF召唤结束后(攻击方, 挨打方,数据)--挣脱
        local 扣血 = math.floor(攻击方.最大气血*0.1)
        local 目标数据 = 攻击方.战场:指令开始()
        攻击方:减少气血(扣血)
        攻击方.战场:指令结束()
        数据:法术后(目标数据)
end

function BUFF:BUFF死亡处理(攻击方, 挨打方)

end


function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
