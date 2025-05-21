local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '祝融取火',
    id = 504,
    是否物理法术 = true,
    种族 = 4
}

local BUFF
function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) <= self:取几率(攻击方) then
            攻击方.伤害 = self:取伤害(攻击方, 挨打方)
            挨打方:被法术攻击(攻击方, self)
            return true
        end
    end
end

function 法术:取基础伤害(攻击方)
    return math.floor(296.1572 + 0.0002364957 * math.pow(攻击方.最大魔法, 1.57))
end

function 法术:取伤害(攻击方, 挨打方)
    local 伤害 = self:取基础伤害(攻击方)
    伤害 = 取仙法伤害('火', 伤害, 攻击方, 挨打方)
    return math.floor(伤害)
end

function 法术:取几率(召唤)
    local ndjl =
        math.floor(
            (math.pow(召唤.等级 * self.等级 * 0.04, 1 / 2) * (1 + 0.25 * self.转生) +
                (math.pow(召唤.亲密, 1 / 6) * 内丹系数调整(召唤.转生, self.转生) * self.等级) / 50) *
            1000
        ) * 0.000004;

    ndjl = math.ceil(ndjl * 10000) / 100
    return ndjl
end

function 法术:法术取描述(召唤)
    local ndjl = self:取几率(召唤)
    local ndcd = self:取基础伤害(召唤)

    return string.format("在物理攻击的时候有#R%.2f%%#W的几率产生#R%s#W火系法术伤害。", ndjl, ndcd)
end

local _bid = { 1307, 1308, 1309, 1316, 1320 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '祝融取火',
    名称 = '内丹特效',
    id = 1307
}
法术.BUFF = BUFF

function BUFF:BUFF添加前(buff)
    if buff.名称 == '内丹特效' then
        self:删除()
    end
end

return 法术
