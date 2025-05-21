-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-10-14 11:04:39
-- @Last Modified time  : 2024-10-31 20:14:04

local 法术 = {
    类别 = '召唤',
    类型 = 0,
    条件 = 1,
    对象 = 2,
    名称 = '讨命',
	--id = 2125,
}


function 法术:召唤兽存在(v)
    local r = v:取召唤信息(v.位置 + 5)
    if r and not r.是否死亡 then
        return r
    end
end


function 法术:回合开始(攻击方,数据)
    if 攻击方:是否PK() then
        local dst = 攻击方:所满足对象(
            function(v)
                if not v.是否死亡 and v.是否玩家 and self:召唤兽存在(v) then
                    return true
                end
            end
        )
        for i,v in ipairs(dst) do 
            local 扣血 = v.等级*17
            local 目标 = v
            if v.气血 <= 扣血 then
                目标 = self:召唤兽存在(v)
            end
            目标:减少气血(扣血)
        end 
    end
end
-- 但是按这个说  不应该掉最大气血比例 ， 直接掉   直接掉固定  3000    

local BUFF

function 法术:法术取描述(攻击方, 挨打方)
    return "具有此技能的召唤兽在场时，所有人物在回合开始时假如有召唤兽在场，则会掉血，人物血量不足时由召唤兽代扣(仅限玩家之间PK时使用)。"
end


return 法术
