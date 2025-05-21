local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '化无',
  --  id = 304,

}

local BUFF
function 法术:进入战斗(攻击方)
    self.已添加 = false
    --战场BUF
end

function 法术:战斗开始(攻击方,数据)
    if not self.已添加 and 攻击方:是否PK() then --
        self.已添加 = true
        for k, v in 攻击方:遍历敌方() do
            local b = v:添加BUFF(BUFF)
            b.回合开始 = 150
            数据:添加BUFF(BUFF.名称,v.位置)
        end
    end
end

function 法术:法术取描述(P)
    return "取消第一个敌方法术，此技能只生效一次(仅限玩家之间PK时使用)!"
end

BUFF = {
    法术 = '化无',
    名称 = '化无',
    --  id = 401
}
法术.BUFF = BUFF


function BUFF:BUFF法术施放前(攻击方, 挨打方,法术,数据)--挣脱
    if 攻击方:取BUFF('化无') then
        for _, v in 攻击方:遍历我方() do
            v:删除指定BUFF('化无')
            数据:删除BUFF('化无',v.位置)
        end
        local 技能名称 = 攻击方.当前法术.数据.名称
        -- 攻击方:删除指定法术(技能名称)
        攻击方:提示("#R你的"..技能名称.."被化掉了！")
        return false
    end
end

function BUFF:BUFF死亡处理(攻击方, 挨打方)

end

return 法术
