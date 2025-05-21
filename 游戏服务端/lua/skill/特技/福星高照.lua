--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-25 11:55:15
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 11:55:28
FilePath: \服务端\lua\skill\特技\福星高照.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 法术 = {
    类别 = '特技',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '福星高照',
    是否被动 = true,
    战斗可用 = true,
}

function 法术:取鬼法增加(攻击方,挨打方,伤害)
    return 伤害 + math.floor(伤害*0.1)
end

function 法术:取仙法增加(攻击方,挨打方,伤害)
    return 伤害 + math.floor(伤害*0.1)
end


return 法术
