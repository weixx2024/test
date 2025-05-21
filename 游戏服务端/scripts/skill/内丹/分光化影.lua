local 法术 = {
    类别 = '内丹',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '分光化影',
    id = 1210,
    种族 = 3
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    if 攻击方.气血 <= 1 then
        return
    end
    local ndxs, ndhq = self:取内丹系数(攻击方)
    local 消耗hp = self:法术取消耗(攻击方, ndxs).消耗HP
    if 攻击方.气血 < 消耗hp then
        攻击方:提示("#R气血不足，无法释放！")
        return false
    end
    self.xh = 消耗hp
    for _, v in ipairs(目标) do
        攻击方.魔法伤害 =self:法术取伤害(攻击方, ndhq)
        攻击方.魔法伤害 =self:取最终伤害(攻击方.魔法伤害,v)
        if 攻击方.魔法伤害 < 1 then 攻击方.魔法伤害 = 1 end
        v:被法术攻击(攻击方, self)
    end
end

function 法术:取最终伤害(伤害,挨打方)
    伤害 = 伤害 - (挨打方.灵犀一点 or 0)
    return math.floor(伤害)
end
--哪些是男模的技能
function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少气血(self.xh)
        self.xh = false
    end
end

function 法术:法术取伤害(攻击方, ndhq)
    local 伤害 = self.xh * ndhq * 0.01  + (攻击方.抗性.分光要诀 or 0)
    if 伤害<1 then
        伤害=1
    end
    return math.floor(伤害)
end

function 法术:取内丹系数(召唤)
    local ndjl =
    math.floor(
        (math.pow((召唤.等级 * self.等级) / 160000, 1 / 2) * (1 + 0.25 * self.转生) +
            (math.pow(召唤.亲密, 1 / 6) * self.等级) / 4000) *
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
    local ndhq =
    math.floor(
        ndjl * ((召唤.等级 * 召唤.等级 * 0.15) / (召唤.最大魔法 * 1 + 0.01) + 0.2) * 1000
    ) / 1000;



    ndxs = math.ceil(ndxs * 10000) / 100
    ndhq = math.ceil(ndhq * 10000) / 100

    return ndxs, ndhq
end

function 法术:法术取描述(召唤)
    local ndxs, ndhq = self:取内丹系数(召唤)
    return string.format("通过牺牲自己HP当前的#R%.2f%%#W给对手造成自己HP当前值#R%.2f%%#W的MP伤害。"
        , ndxs, ndhq)
end

function 法术:法术取消耗(攻击方, ndxs)
    if not ndxs then
        ndxs = self:取内丹系数(攻击方) --技能描述
    end
    return { 消耗HP = math.floor(攻击方.气血 * ndxs * 0.01) }
end

function 法术:法术取目标数()
    return 1
end

local _bid = {1310, 1311, 1312, 1317,1321}
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '分光化影',
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

--消耗百分比=(等级+单位.等级)*0.1279*(转生*0.25)+(等级+单位.等级)*0.1279*(亲密度^0.051334)
--消耗=消耗百分比*当前HP
--伤害百分比=(等级+单位.等级)*0.0255*(转生*0.25)+(等级+单位.等级)*0.0255*(亲密度^0.054965)+608645/MP值
--伤害=消耗*伤害百分比
--    分光化影 = "此技能通过牺牲自己的HP给对手造成MP伤害。",
