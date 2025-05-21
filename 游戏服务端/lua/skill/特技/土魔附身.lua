--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-25 09:07:30
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 11:30:47
FilePath: \服务端\lua\skill\特技\土魔附身.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '土魔附身',
    是否被动 = true,
}

function 法术:计算_后特技(P,dj)
    P.土 = P.土 + 100
    P.抗性.强力克火 = (P.抗性.强力克火 or 0) + 50
   
end

return 法术
