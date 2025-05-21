local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '黄泉一笑',
    是否被动 = true,
}
-- 物理攻击每致死1个目标，可为本方死亡单位回复60%最大血量(优先主人)，每回合最多可回复2个目标。

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
    法术 = '黄泉一笑',
    名称 = '黄泉一笑',
}
法术.BUFF = BUFF

function BUFF:物理攻击(攻击方, 挨打方)
    local 气血 = 挨打方.气血

    if 气血 <= 0 then
        local 死亡列表 = 攻击方:取我方死亡玩家(1, true)
        if next(死亡列表) ~= nil then
            攻击方.当前数据:喊话('黄泉一笑#2')
            for k, v in pairs(死亡列表) do
                v:增加气血(math.ceil(v.最大气血 * 0.6))
                v.是否死亡 = nil
            end
        end
    end
end

function 法术:法术取描述()
    return '物理攻击每致死1个目标，可为本方死亡单位回复60%最大血量(优先主人)，每回合最多可回复2个目标。' --之前我只有这一个 宝宝复
end

return 法术
