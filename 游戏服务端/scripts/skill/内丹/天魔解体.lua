local 法术 = {
    类别 = '内丹',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '天魔解体',
    id = 1209,
    种族 = 3
}

local BUFF

function 法术:法术施放(攻击方, 目标) --这是主动法术是吧是
    if 攻击方.气血 <= 1 then
        return
    end
    local ndxs, ndhq = self:取内丹系数(攻击方)
    local 消耗hp = self:法术取消耗(攻击方, ndxs).消耗HP
    if 攻击方:取气血() < 消耗hp then
        攻击方:提示("#R气血不足，无法释放！")
        return false
    end
    self.xh = 消耗hp
    for _, v in ipairs(目标) do
        攻击方.伤害 = self:法术取伤害(攻击方, ndhq)
        攻击方.伤害 = self:取最终伤害(攻击方.伤害,v)
        if 攻击方.伤害 < 1 then
            攻击方.伤害 = 1
        end
        v:被法术攻击(攻击方, self)
    end
end

function 法术:取最终伤害(伤害,挨打方)
    伤害 = 伤害 - (挨打方.化血成碧 or 0)
    return math.floor(伤害)
end


function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少气血(self.xh)
        self.xh = false
    end
end

function 法术:法术取伤害(攻击方, ndhq)
    local 伤害 = self.xh * ndhq * 0.01 +   (攻击方.抗性.天魔要诀 or 0)
    return math.floor(伤害)
end

function 法术:法术取消耗(攻击方, ndxs)
    if not ndxs then
        ndxs = self:取内丹系数(攻击方) --技能描述
    end
    return { 消耗HP = math.floor(攻击方.气血 * ndxs * 0.01) }
end

function 法术:取内丹系数(召唤)
    local ndjl = 0
    if 召唤.转生 == 0 then
        ndjl =
        math.floor(
            (math.pow((召唤.等级 * self.等级) / 160000, 1 / 2) * (1 + 0.25 * self.转生) +
                (math.pow(召唤.亲密, 1 / 6) * self.等级) / 4000) *
            1000
        ) /
            1000 +
            0.01;
    else
        ndjl =
        math.floor(
            (math.pow((召唤.等级 * self.等级) / 160000, 1 / 2) * (1 + 0.25 * self.转生) +
                (math.pow(召唤.亲密, 1 / 6) * self.等级) / 3755) *
            1000
        ) /
            1000 +
            0.01;
    end
    local ndxs = 0
    if ndjl > 0.999 then
        ndxs = 0.999
    else
        ndxs = ndjl
    end



    local ndhq =
    math.floor(
        ndjl * ((召唤.等级 * 召唤.等级 * 0.15) / (召唤.最大气血 * 1 + 0.01) + 0.2) * 1000
    ) / 1000;

    ndxs = math.ceil(ndxs * 10000) / 100
    ndhq = math.ceil(ndhq * 10000) / 100
    return ndxs, ndhq

end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取描述(召唤)
    local ndxs, ndhq = self:取内丹系数(召唤)
    return string.format("通过牺牲自己HP当前的#R%.2f%%#W给对手造成自己HP当前值#R%.2f%%#W的HP伤害。"
        , ndxs, ndhq)
end

local _bid = { 1310, 1311, 1312, 1317,1321}
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '天魔解体',
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
-- 取整前=(等级+单位.等级)*0.1279*(转生*0.25)+(等级+单位.等级)*0.1279*(亲密度^0.051334)
-- 取整前2=(等级+单位.等级)*0.0255*(转生*0.25)+(等级+单位.等级)*0.0255*(亲密度^0.054965)--+608645/MP值
-- if 取整前>99.99 then
--     取整前=99.99
-- end
-- if 取整前2>90 then
--    取整前2=90
-- end

-- 单位.天魔解体={}
-- 单位.天魔解体.消耗=qz(取整前*100)/100
-- 单位.天魔解体.伤害=qz(取整前2*100)/100
-- 单位.天魔解体.伤害基础=0
--此技能通过牺牲自己的HP给对手造成HP伤害。
--    天魔解体 = "此技能通过牺牲自己的HP给对手造成HP伤害。",
