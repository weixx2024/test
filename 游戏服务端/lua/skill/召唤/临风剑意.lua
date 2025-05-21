-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2024-09-28 22:27:26
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '临风剑意',
    是否被动 = true,
}

function 法术:临风剑意计算(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) < self:取几率(攻击方) or 攻击方.触发剑荡八荒 then
            return true
        end
    end
end
function 法术:临风剑意附加(攻击方, 挨打方)
    攻击方.触发剑荡八荒 = nil
    local dst = 挨打方:取附近目标(挨打方.位置)
    for i,v in ipairs(dst) do
        攻击方 = 攻击方:物理_生成对象('物理', v)
        攻击方.躲避 = false
        攻击方.禁反震 = true
        攻击方.禁反击 = true
        攻击方.禁保护 = true
        if 攻击方.气血 > 0 then
            v:被物理攻击(攻击方,v)
        end
    end
    return true
end

function 法术:取伤害(攻击方, 挨打方)
    local ndcd = math.floor(296.1572 + 0.0002364957 * math.pow(攻击方.最大魔法, 1.57));
    return math.floor(ndcd)
end

function 法术:取几率(召唤)
    local qm = 召唤.亲密
    return  math.floor(50 + SkillXS(qm,0.1))
end


function 法术:法术取描述(召唤)
    return string.format("攻击时有几率释放一道临风剑意，对前方扇形范围内的敌方目标造成物理伤害，连续释放多次时伤害效果减弱。")
end



return 法术
