local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '乱舞狂刀',
    是否被动 = true,
}
-- 物理攻击时若触发隔山，隔山目标有几率增加1个，有几率增加2个，有几率增加3个。 （几率最高值分别为75%/42%/22%）

local BUFF
function 法术:进入战斗(自己)
    local b = 自己:进入战斗添加BUFF(BUFF)
    b.回合 = 150
end

function 法术:召唤进入战斗(攻击方,数据,目标,闪现)
    local b = 目标:进入添加BUFF(BUFF)
    b.回合 = 150
end


BUFF = {
    法术 = '乱舞狂刀',
    名称 = '乱舞狂刀',
}
法术.BUFF = BUFF

function BUFF:物理攻击(攻击方, 挨打方)
    local 几率 = math.random(100)
    local 数量 = 0
    local 内丹 = 攻击方:召唤_取内丹('隔山打牛')
    if 内丹 then
        local ndjl, ndcd = 内丹:取内丹(攻击方)
        if 几率 <= 22 then
            数量 = 3
        elseif 几率 <= 42 then
            数量 = 2
        elseif 几率 <= 75 then
            数量 = 1
        end

        if 数量 == 0 then
            return
        end

        攻击方.当前数据:喊话('乱舞狂刀#2')

        local 隔山列表 = 挨打方:随机我方(
            数量,
            function(v)
                if not v.是否死亡 and not v.是否隐身 and not v:取BUFF('封印') and (not 挨打方 or 挨打方 ~= v) then
                    return true
                end
            end
        )

        if next(隔山列表) ~= nil then
            攻击方.伤害 = math.floor(攻击方.伤害 * ndcd * 0.01)
            if 攻击方.伤害 < 1 then
                攻击方.伤害 = 1
            end
            for k, v in pairs(隔山列表) do
                v:被法术攻击(攻击方, BUFF)
            end
        end
    end
end

function 法术:法术取描述()
    return '物理攻击时若触发隔山，隔山目标有几率增加1个，有几率增加2个，有几率增加3个。'
end

return 法术
