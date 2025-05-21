--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-03-03 23:08:20
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-03-05 23:29:27
FilePath: \服务端1\scripts\skill\内丹\浩然正气.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 法术 = {
    类别 = '内丹',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '浩然正气',
    id = 1213,
    是否物理法术 = true,
    种族 = 1
}

local BUFF
function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        local ndjl, ndcd = self:取内丹(攻击方)
        if math.random(100) <= ndjl then --
            挨打方.最大魔法 = 挨打方.最大魔法
            if 挨打方.最大魔法 > 100000 then
                挨打方.最大魔法 = 100000
            end
            攻击方.伤害 = math.floor(挨打方.最大魔法 * ndcd * 0.01)
            攻击方.伤害 = self:取最终伤害(攻击方.伤害, 挨打方)
            if 攻击方.伤害 < 1 then
                攻击方.伤害 = 1
            end
            挨打方:被法术攻击(攻击方, self)
            return true
        end
    end
end

function 法术:取最终伤害(伤害, 挨打方)
    伤害 = 伤害 - (挨打方.上善若水 or 0)
    return math.floor(伤害)
end

function 法术:取内丹(召唤)
    local ndjl =
        math.floor(
            (math.pow(召唤.等级 * self.等级 * 0.04, 1 / 2) * (1 + 0.25 * self.转生) +
                (math.pow(召唤.亲密, 1 / 6) * 内丹系数调整(召唤.转生, self.转生) * self.等级) / 50) *
            1000
        ) * 0.000005;

    local ndcd =
        math.floor(((召唤.等级 * 召唤.等级 * 0.2) / (召唤.最大魔法 * 1 + 1) + ndjl) * 10000) /
        10000;
    -- ndjl = math.ceil(ndjl * 10000) / 100 + (召唤.抗性.浩然几率 or 0)
    ndjl = math.ceil(ndjl * 10000) / 100 + (召唤.浩然几率 or 0)
    ndcd = math.ceil(ndcd * 10000) / 100
    return ndjl, ndcd
end

function 法术:法术取描述(召唤)
    local ndjl, ndcd = self:取内丹(召唤)
    return string.format("召唤兽物理攻击，有#R%.2f%%#W几率附加造成按对方自身法力#R%.2f%%#W的伤害。"
    , ndjl, ndcd)
end

local _bid = { 1304, 1305, 1306, 1315, 1319 }
function 法术:切换内丹BUFF(召唤)
    BUFF.id = _bid[self.转生 + 1]
    召唤:添加BUFF(BUFF)
end

BUFF = {
    法术 = '浩然正气',
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
