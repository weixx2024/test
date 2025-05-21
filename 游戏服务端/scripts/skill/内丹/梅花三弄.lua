local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '梅花三弄',
    种族 = 2 --天界
}

local BUFF
function 法术:法术施放后(攻击方, 目标)
    if 攻击方.当前法术.是否仙法 then
        local jl, cs = self:取机率(攻击方)
        if math.random(100) < jl then
            攻击方.连击次数 = cs
        end
    end
end


local function nd_mhsn_ljcs(mhsn)
    if mhsn > 0.28 then return 5;
    elseif mhsn > 0.21 then return 4;
    elseif mhsn > 0.14 then return 3;
    elseif mhsn > 0.7 then return 2;
    else
        return 1;
    end
end

function 法术:取机率(召唤)
    local ndjl =
    math.floor(
        (math.pow(召唤.等级 * self.等级 * 0.04, 1 / 2) * (1 + 0.25 * self.转生) +
            (math.pow(召唤.亲密, 1 / 6) * 内丹系数调整(召唤.转生, self.转生) * self.等级) / 50) *
        1000
    ) * 0.000005;
    return math.ceil(ndjl * 10000) / 100, nd_mhsn_ljcs(ndjl);
end

function 法术:法术取描述(召唤)
    local ndjl, ndcd_jldl = self:取机率(召唤)

    return string.format("此技能在使用仙法攻击的时候有#R%.2f%%#W几率出现法术#R%s#W次连击。",
        ndjl,
        ndcd_jldl
    )
end

local _bid = { 1301, 1302, 1303,  1314, 1318 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '梅花三弄',
    名称 = '内丹特效',
    id = 1301
}
法术.BUFF = BUFF

function BUFF:BUFF添加前(buff)
    if buff.名称 == '内丹特效' then
        self:删除()
    end
end

return 法术
-- 取整前=(等级+单位.等级)*0.05*(转生*0.25)+(等级+单位.等级)*0.05*(亲密度^0.05604)--2.4676--41.95
-- 取整前2=1+qz((取整前-15)/6.7375)
-- if 取整前2>=4 then
--   取整前2=4
-- end
-- 单位.法术连击率=单位.法术连击率+qz(取整前*100)/100
-- 单位.法术次数= 单位.法术次数+qz(取整前2)
--梅花三弄    梅花三弄 = "此技能在使用仙法攻击的时候有一定几率出现法术连击。",
