--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-25 19:05:13
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 19:05:19
FilePath: \服务端\lua\skill\特技\梅花三弄.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '梅花三弄',
    种族 = 2 --天界
}

local BUFF
function 法术:法术施放后(攻击方, 目标)
    -- if 攻击方.当前法术.是否仙法 then
        local jl = self:取机率(攻击方)
        if math.random(100) < jl then
            攻击方.连击次数 = 3
        end
    -- end
end


function 法术:取机率(召唤)
    local ndjl = 30
    return ndjl
end


return 法术
