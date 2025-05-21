local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '凌波微步',
    种族 = 1
}
local BUFF
function 法术:法术施放(攻击方, 目标)

end


function 法术:公式(召唤)
    local ndjl = math.floor(
        (math.pow(召唤.等级 * self.等级 * 0.04, 1 / 2) * (1 + 0.25 * self.转生) +
            (math.pow(召唤.亲密, 1 / 6) * 内丹系数调整(召唤.转生, self.转生) * self.等级) / 50) *
        1000
    ) * 0.00001;
    ndjl = math.ceil(ndjl * 10000) / 100
    return ndjl
end

function 法术:法术取描述(召唤)
    local ndjl = self:公式(召唤)
    return string.format("此技能提高召唤兽#R%.2f%%#W的躲闪率。", ndjl)
end

function 法术:计算(召唤)
    local ndjl = self:公式(召唤)
    local list = { 躲闪率 = ndjl }
    return list
end

local _bid = { 1304, 1305, 1306,1315, 1319 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '凌波微步',
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
-- 取整前=(等级+单位.等级)*0.1*(转生*0.25)+(等级+单位.等级)*0.1*(亲密度^0.0589)--2.4679--83.91
-- 单位.躲闪率=单位.躲闪率+qz(取整前*100)/100
--    凌波微步 = "此此技能提高召唤兽一定的躲闪率。",
