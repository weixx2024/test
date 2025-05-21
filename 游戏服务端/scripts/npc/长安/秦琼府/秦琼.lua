local NPC = {}
local 对话 = [[
长安有东、西两个城门，出了城门有时会有妖怪出没，可要小心啊。
]]
local 对话2 = [[
长安有东、西两个城门，出了城门有时会有妖怪出没，可要小心啊。
menu
20|我要领取法宝
]]
function NPC:NPC对话(玩家, i)
    if not 玩家:取法宝是否存在("将军令") and 玩家.转生 > 0 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '20' then
        if 玩家.转生 < 1 then
            return "1转后再来找我领取哦"
        end
        local r = 玩家:取任务("法宝领取")
        if r then
            return "你身上还有未完成的法宝任务哦"
        end
        local rw = 生成任务 { 名称 = '法宝领取', 法宝 = '将军令' }
        return rw:添加任务(玩家)
    end
end

return NPC
