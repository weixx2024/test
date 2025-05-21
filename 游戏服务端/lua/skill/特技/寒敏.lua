--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-25 09:07:30
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 11:26:19
FilePath: \服务端\lua\skill\特技\寒敏.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '寒敏',
    是否被动 = true,
}

function 法术:计算_后特技(P,dj)
    local 敏捷 = P.装备属性.敏捷 + P.敏捷 + P.其它.四维加成 * 10
    P.抗性.忽视抗睡 = (P.抗性.忽视抗睡 or 0) + math.floor(敏捷/10/10)
end

return 法术
