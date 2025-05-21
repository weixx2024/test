local NPC = {}
local 对话 = [[
高级装备拥有不俗的能力和低廉的价格，行侠三界就靠它了！
menu
1|我要打造装备
2|我要镶嵌宝石
99|我什么都不想做
]]
local 对话2 = [[
0(∩_∩)0哈哈~，有些武器看起来不起眼，但若经过上好矿石的打造，也会非常出众呢#28
menu
3|找我什么事?
98|请多关照
]]
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('新手剧情')
    if r and r.进度 == 10 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:装备打造窗口()
    elseif i == '2' then
        玩家:打开窗口("装备镶嵌",玩家.银子)
    end
end

return NPC
