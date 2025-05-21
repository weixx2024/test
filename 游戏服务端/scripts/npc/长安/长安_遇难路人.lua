--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-02-18 11:42:11
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-02-24 23:00:34
FilePath: \服务端\scripts\npc\长安\长安_遇难路人.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]


local NPC = {}
local 对话 = [[天杀的修罗占领了我们的家园，我现在只能到处流浪了#52我可以带领你去修罗古城和灵兽村，你随便给我点带路费就行了。
menu
修罗古城  
灵兽村 
我什么都不想做 
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='战斗测试' then
        --玩家:进入战斗('测试')
    elseif i=='物品测试' then
        --玩家:增加物品(生成道具('四叶花'))
    elseif i=='召唤兽测试' then
        --玩家:增加召唤(生成召唤('大海龟'))
    end
end

return NPC