--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-25 18:26:40
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 18:31:15
FilePath: \服务端\lua\skill\特技\霹雳流星.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '霹雳流星',
    id = 604,
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
    伤害 = 取仙法伤害('雷', 伤害, 攻击方, 挨打方)
    return math.floor(伤害)
end

function 法术:取几率(召唤)
    local ndjl = 10
    return ndjl
end

return 法术
