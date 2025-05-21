local 法术 = {
    类别 = '内丹',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '青面獠牙',
    id = 1211,
    种族 = 3
}
local BUFF
function 法术:法术施放(攻击方, 目标)
    local ndxs, ndhq = self:取内丹系数(攻击方)
    local 消耗MP = self:法术取消耗(攻击方, ndxs).消耗MP
    if 攻击方:取魔法() < 消耗MP then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗MP
    for _, v in ipairs(目标) do
        攻击方.伤害 = self:法术取伤害(攻击方, ndhq)
        攻击方.伤害 = self:取最终伤害(攻击方.伤害,v)
        v:被法术攻击(攻击方, self)
    end
end

function 法术:取最终伤害(伤害,挨打方)
    伤害 = 伤害 - (挨打方.美人迟暮 or 0)
    return math.floor(伤害)
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh = false
    end
end
function 法术:法术取目标数()
    return 1
end
function 法术:法术取伤害(攻击方, ndhq)
    local 伤害 = self.xh*ndhq* 0.01 +   (攻击方.抗性.青面要诀 or 0) ---攻击方:取气血() * ndhq * 0.01
    return math.floor(伤害)
end
function 法术:法术取描述(召唤)
    local ndxs, ndhq = self:取内丹系数(召唤)
    return string.format("通过牺牲自己MP当前的#R%.2f%%#W给对手造成自己HP当前值#R%.2f%%#W的HP伤害。", ndxs, ndhq)
end

function 法术:法术取消耗(攻击方, ndxs)
    if not ndxs then
        ndxs = self:取内丹系数(攻击方) --技能描述
    end
    return { 消耗MP = math.floor(攻击方.魔法 * ndxs * 0.01) }
end

function 法术:取内丹系数(召唤)
    local ndjl =
    math.floor(
        (math.pow((召唤.等级 * self.等级) / 698000, 1 / 2) * (1 + 0.25 * self.转生) +
            (math.pow(召唤.亲密, 1 / 6) * self.等级) / 7500) *
        1000
    ) /
        1000 +
        0.01;
    local ndxs = 0
    if ndjl > 0.999 then
        ndxs = 0.999
    else
        ndxs = ndjl
    end
    local ndhq = ndjl * 0.7;
    ndxs = math.ceil(ndxs * 10000) / 100
    ndhq = math.ceil(ndhq * 10000) / 100
    return ndxs, ndhq
end

local _bid = { 1310, 1311, 1312, 1317,1321}
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '青面獠牙',
    名称 = '内丹特效',
    id = 1310
}
法术.BUFF = BUFF

function BUFF:BUFF添加前(buff)
    if buff.名称 == '内丹特效' then
        self:删除()
    end
end

return 法术
-- 单位.主动技能[#单位.主动技能+1]={名称="青面獠牙",熟练度=单位.等级}
-- 取整前=(等级+单位.等级)*0.0626*(转生*0.25)+(等级+单位.等级)*0.0626*(亲密度^0.0584)
-- 取整前2=(等级+单位.等级)*0.0438*(转生*0.25)+(等级+单位.等级)*0.0438*(亲密度^0.0584)
-- if 取整前>99.99 then
--   取整前=99.99
-- end
-- 单位.青面獠牙={}
-- 单位.青面獠牙.伤害基础=0
-- 单位.青面獠牙.消耗=qz(取整前*100)/100
-- 单位.青面獠牙.伤害=qz(取整前2*100)/100
--此技能通过牺牲自己的MP给对手造成HP伤害。
--    青面獠牙 = "此技能通过牺牲自己的MP给对手造成HP伤害。",
