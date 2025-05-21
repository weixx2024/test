local NPC = {}
local 对话 = [[
别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
1|我想要回长安
]]
local 对话2 = [[
都说神仙好，神仙的烦恼又有谁知道
menu
1|我想要回长安
20|我要领取法宝
]]

function NPC:NPC对话(玩家, i)
    if not 玩家:取法宝是否存在("锦襕袈裟") and 玩家.转生 > 0 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1001, 332, 24)
    elseif i == '20' then
        if 玩家.转生 < 1 then
            return "1转后再来找我领取哦"
        end
        local r = 玩家:取任务("法宝领取")
        if r then
            return "你身上还有未完成的法宝任务哦"
        end
        local rw = 生成任务 { 名称 = '法宝领取', 法宝 = '锦襕袈裟' }
        return rw:添加任务(玩家)
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
