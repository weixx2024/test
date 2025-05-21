-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2024-10-29 13:29:15
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '蜃光流星',
    是否被动 = true,
}

local BUFF
function 法术:蜃光流星计算(攻击方, 挨打方,n)
    if 挨打方 then
        if n == nil then
            return true
        else
            if n==1 then
                if math.random(100) < self:取几率(攻击方) then
                    return true
                end
            else
                if math.random(100) < self:取副几率(攻击方) then
                    return true
                end
            end
        end
    end
end

function 法术:蜃光流星计附加(攻击方, 挨打方)
    攻击方.伤害 = self:取伤害(攻击方, 挨打方)
    local 临时目标数据 = {}
    local cs = 5
    local 位置 = 挨打方.位置
    for i=1,cs do
        local dst = 挨打方:取附近一格目标(位置)
        if dst then
            临时目标数据[i] = dst.位置
            dst:被法术攻击(攻击方,self)
            位置 = dst.位置
        end
    end
    return 法术.名称,临时目标数据
end


function 法术:取伤害(攻击方, 挨打方)
    local ndcd = math.floor(296.1572 + 0.0003364957 * math.pow(攻击方.最大魔法, 1.57));
    --local ndcd = (500+攻击方.最大魔法*0.01)
    return math.floor(ndcd)
end

function 法术:取几率(召唤)
    local qm = 召唤.亲密 or 0
    return math.floor(40 + SkillXS(qm,0.178))
    
end

function 法术:取副几率(召唤)
    local qm = 召唤.亲密 or 0
    return math.floor(20 + SkillXS(qm,0.26))
end

function 法术:法术取描述(召唤)
    return string.format("使用1-4阶仙法时有几率对目标造成一次可连续折射的蜃景伤害(折射距离为1，首次伤害与自身法力上限和敌方仙法抗性相关)，每次折射倍率随机，可连续折射多次。")
end

return 法术
