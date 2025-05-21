local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '借力打力',
    种族 = 1
}

local BUFF

local function nd_jldl_fjcs(jl)
    if jl > 0.56 then return 9;
    elseif jl > 0.51 then return 8;
    elseif jl > 0.45 then return 7;
    elseif jl > 0.39 then return 6;
    elseif jl > 0.32 then return 5;
    elseif jl > 0.25 then return 4;
    elseif jl > 0.17 then return 3;
    elseif jl > 0.09 then return 2;
    else
        return 1;
    end
end

function 法术:公式(召唤)
    local ndjl = math.floor(
        (math.pow(召唤.等级 * self.等级 * 0.04, 1 / 2) * (1 + 0.25 * self.转生) +
            (math.pow(召唤.亲密, 1 / 6) * 内丹系数调整(召唤.转生, self.转生) * self.等级) / 50) *
        1000
    ) * 0.00001;
    local ndcd_jldl = nd_jldl_fjcs(ndjl);
    ndjl = math.ceil(ndjl * 10000) / 100
    return ndjl, ndcd_jldl
end

function 法术:法术取描述(召唤)
    local ndjl, ndcd_jldl = self:公式(召唤)

    return string.format("此技能在受到物理攻击的一回合内有#R%.2f%%#W%%的几率产生反击效果。反击次数为#R%s#W次"
        , ndjl, ndcd_jldl)
end

function 法术:计算(召唤)
    local ndjl, ndcd_jldl = self:公式(召唤)
    local list = { 反击率 = ndjl, 反击次数 = ndcd_jldl }
    return list
end

local _bid = { 1304, 1305, 1306,1315, 1319}
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '借力打力',
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



-- 取整前=(等级+单位.等级)*0.1*(转生*0.25)+(等级+单位.等级)*0.1*(亲密度^0.056048)--2.4679--83.91
-- 单位.反击率=单位.反击率+qz(取整前*100)/100
-- 单位.反击次数=单位.反击次数+qz(1+取整前/9)
-- if 单位.反击次数>7 then
--   单位.反击次数=7
-- end
--    借力打力 = "此技能在受到物理攻击的一回合内有一定的几率产生反击效果。",
