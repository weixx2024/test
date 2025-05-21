--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-25 18:27:53
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 18:33:47
FilePath: \服务端\lua\skill\特技\风雷涌动.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-25 18:27:53
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 18:32:25
FilePath: \服务端\lua\skill\特技\风雷涌动.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 法术 = {
    类别 = '特技',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '风雷涌动',
    id = 704,
    是否物理法术 = true,
    是否仙法 = true
}

function 法术:物理法术(攻击方, 挨打方)
    if 挨打方 then
        if math.random(100) <= self:取几率(攻击方) then
            攻击方.伤害 = self:法术取伤害(攻击方, 挨打方)
            挨打方:被法术攻击(攻击方, self)
            return true
        end
    end
end

function 法术:取几率(召唤)
    local ndjl = 10
    return ndjl
end

function 法术:法术基础伤害(攻击方)
    local 等级 = 攻击方.等级 + 1
    local 伤害 = 等级 * (64.98918 + 2.03423 * self.熟练度 ^ 0.4)
    return math.floor(伤害)
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = self:法术基础伤害(攻击方)
    伤害 = 取仙法伤害('风', 伤害, 攻击方, 挨打方)
    return math.floor(伤害)
end


return 法术
