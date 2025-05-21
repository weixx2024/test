-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-07 18:25:22
-- @Last Modified time  : 2022-08-13 06:40:20
local 法术 = {
    类别 = '召唤',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    -- 物理法术 = true,
    名称 = '兵临城下',
    id = 0107,
}
local BUFF
function 法术:法术施放(攻击方, 目标,this)
    local 消耗 = self:法术取消耗(攻击方)
    if 攻击方:取魔法() < 消耗.消耗MP then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    if 攻击方.气血 < 消耗.消耗HP then
        攻击方:提示("#R气血不足，无法释放！")
        return false
    end
    self.xh = 消耗
    local b = 攻击方:添加BUFF(BUFF)
    if b then
        b.回合 = 1
    end
    攻击方.指令 = "物理"
    攻击方.已行动 = false
    攻击方.目标 =  目标[1].位置
    攻击方:置重复操作()
    攻击方:当前喊话("看我的兵临城下")
end

function 法术:法术施放后(攻击方, 目标,法术,this)
    if self.xh then
        攻击方:减少气血(self.xh.消耗HP)
        攻击方:减少魔法(self.xh.消耗MP)
        self.xh=false
    end
    
end

function 法术:法术取消耗(P)
    local HP = math.floor(P.最大气血 * 0.5)+1
    local MP = math.floor(P.最大魔法 * 0.2)
    return { 消耗MP = MP, 消耗HP = HP }
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取描述()
    return '兵临城下，将至壕边，只待破釜沉舟，大战一场。#r#G消耗自身50%气血和20%法力上限(气血或魔法不足无法释放技能)，将伤害提至2.5倍'
end


BUFF = {
    法术 = '兵临城下',
    名称 = '兵临城下',
    -- id = 201
}
法术.BUFF = BUFF


function BUFF:BUFF物理攻击后(攻击方,目标)
    攻击方.伤害 = math.floor(攻击方.伤害 * 2.5)
end


function BUFF:BUFF回合结束()
    self:删除()
end

return 法术
