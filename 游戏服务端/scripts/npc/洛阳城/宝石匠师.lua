local NPC = {}
local 对话 = [[
艺之所在，全赖匠心独运。从我这出去的每一颗宝石都是精雕细琢，独一无二的。
menu
1|我要合成宝石
2|我要镶嵌宝石
3|生活技能之宝石重铸
4|我要鉴定奇异石
5|我要摘除宝石
6|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end



function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:打开窗口("宝石合成",玩家.银子)   
    elseif i == '2' then
        玩家:打开窗口("装备镶嵌高级",玩家.银子)          
    elseif i == '3' then   
        玩家:打开窗口("宝石重铸",玩家.银子)   
    elseif i == '4' then
        玩家:打开窗口("宝石鉴定",玩家.银子)        
    elseif i == '5' then
        玩家:打开窗口("宝石摘除",玩家.银子) 
    end
end

return NPC
