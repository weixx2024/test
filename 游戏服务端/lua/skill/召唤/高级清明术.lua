--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-11 22:46:28
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 12:15:32
FilePath: \服务端\lua\skill\召唤\高级清明术.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-11 22:46:28
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-25 12:15:30
FilePath: \服务端\lua\skill\召唤\高级清明术.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
local 法术 = {
    类别 = '召唤',
    类型 = 2,
    对象 = 0,
    条件 = 1,
    名称 = '高级清明术',
    id = 304,

}



function 法术:回合开始(攻击方, 挨打方)
    if 攻击方:取BUFF('混乱') then
        local 几率 = self:取几率(攻击方, 挨打方)
        if 几率 > math.random(100) then
            攻击方:添加特效(2114)
            攻击方:删除BUFF('混乱')
        end
    end
end

function 法术:取几率(攻击方, 挨打方)
    local qm = 攻击方.亲密 or 0
    return math.floor(30 + qm*0.004)
end

function 法术:法术取描述(P)
    return string.format("本来无一物，何处惹尘埃，灵台一点尽空明，令自己摆脱混乱。#r【消耗MP】0#r#G回合开始时有几率摆脱混乱状态",self:取几率(P))
end

return 法术
