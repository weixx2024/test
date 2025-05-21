local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '作鸟兽散',
    是否被动 = true,
}

local BUFF

function 法术:进入战斗(攻击方)
    -- 攻击方:添加特效(2151)
    local 主人  = 攻击方:取主人()
    if 主人 then
        local a = 主人:进入战斗添加BUFF(BUFF)
        a.回合 = 150
    end
end

function 法术:召唤进入战斗(攻击方,数据,召唤)
    local a = 攻击方:进入添加BUFF(BUFF)
    a.回合 = 150
    数据:添加BUFF(2151,攻击方.位置)
end


function 法术:法术取描述()
    return '当主人倒地，且友方召唤兽只剩自身在场时清除任何状态立即触发回复友方人物50%的血法后离场。'
end


BUFF = {
    法术 = '作鸟兽散',
    名称 = '作鸟兽散',
    id = 901
}

function BUFF:BUFF死亡处理(攻击方, 挨打方)
    if 挨打方 then
        if 挨打方.是否死亡 and 挨打方:遍历我方存活召唤() ==1 then
            return true
        end
    end
end

function BUFF:BUFF死亡处理结果(攻击方, 挨打方)
    local r = 挨打方:取召唤信息(挨打方.位置 + 5)
    if r and not r.是否死亡 and r:取技能是否存在("作鸟兽散") then
        for i,v in 挨打方:遍历我方玩家() do
            v:增加气血(math.floor(v.最大气血*0.5), 2152)
            v:增加魔法(math.floor(v.最大魔法*0.5),2)
            v:删除所有BUFF(挨打方.位置)
            if v.气血 > 0 then
                v.是否死亡 = false
            end
        end
        r:减少气血(r.气血)
    end
end


法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end




return 法术
