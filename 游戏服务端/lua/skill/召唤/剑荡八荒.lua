-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2024-09-28 18:47:40
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '剑荡八荒',
    是否特殊物理法术 = true,
    是否被动 = true,
}

function 法术:回合开始(攻击方, 挨打方)
    self.触发剑荡八荒 = nil
end


function 法术:特殊物理法术(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) < self:取几率(攻击方) and not 攻击方.触发连击 then
            return true
        end
    end
end

function 法术:特殊物理法术附加(攻击方, 挨打方)
    攻击方.触发剑荡八荒 = 1
    攻击方:当前喊话("剑荡八方#2")
    if 攻击方.气血 > 0 then
        攻击方.禁反震 = true
        攻击方.禁反击 = true
        攻击方.禁保护 = true
        挨打方:被物理攻击(攻击方, 挨打方)
    end
end

function 法术:取伤害(攻击方, 挨打方)
    local ndcd = math.floor(296.1572 + 0.0002364957 * math.pow(攻击方.最大魔法, 1.57));
    return math.floor(ndcd)
end

function 法术:取几率(召唤)
    local qm = 召唤.亲密
    return  math.floor(45 + SkillXS(qm,0.15))
end

function 法术:法术取描述(召唤)
    return string.format("剑出斩青云，剑落惊归鸿，八荒皆荡尽，四海衣临风。物理攻击命中敌方后有几率触发剑荡八荒，触发后对目标再进行一次攻击，且攻击时有几率释放一道临风剑意，对前方扇形范围内的敌方目标造成物理伤害，连续释放多次时伤害效果减弱。")
end



return 法术
