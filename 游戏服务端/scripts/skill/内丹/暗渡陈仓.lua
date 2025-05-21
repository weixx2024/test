local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '暗渡陈仓',
    种族 = 1
}

local BUFF
function 法术:物理攻击前(攻击方)
    if 攻击方.躲避 then
        if math.random(100) <=  self:取几率(攻击方) then
            攻击方.躲避 = false
        end
    end
    if 攻击方.反击次数 > 0 then
        if math.random(100) <=  self:取几率(攻击方) then
            攻击方.反击次数 = 0
        end
    end
end

function 法术:取几率(召唤)
    local ndjl = math.floor(
        (math.pow(召唤.等级 * self.等级 * 0.04, 1 / 2) * (1 + 0.25 * self.转生) +
            (math.pow(召唤.亲密, 1 / 6) * 内丹系数调整(召唤.转生, self.转生) * self.等级) / 50) *
        1000
    ) * 0.000005
    ndjl = math.ceil(ndjl * 10000) / 100
    return ndjl
end

function 法术:法术取描述(召唤)
    local ndjl = self:取几率(召唤)
    return string.format("此技能在物理攻击的时候能够忽视对手#R%.2f%%#W的躲闪和反击进行攻击。", ndjl)
end

local _bid = { 1304, 1305, 1306,1315, 1319 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '暗渡陈仓',
    名称 = '内丹特效',
    id = 1304
}
法术.BUFF = BUFF

function BUFF:BUFF添加前(buff)
    if buff.名称 == '内丹特效' then
        self:删除()
    end
end

return 法术
-- 取整前=(等级+单位.等级)*0.05*(转生*0.25)+(等级+单位.等级)*0.05*(亲密度^0.05604)
-- 单位.忽视躲闪率=单位.忽视躲闪率+qz(取整前*100)/100
-- 单位.忽视反击率=单位.忽视反击率+qz(取整前*100)/100
