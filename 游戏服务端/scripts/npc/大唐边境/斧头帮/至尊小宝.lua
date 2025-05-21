local NPC = {}
local 对话 = [[村口来了个白衣文士在那呆了许久，呆着几只灵兽守住门口不让兄弟们出入，你去帮我把他收拾了！
]]
function NPC:NPC对话(玩家, i)
    if 坐骑任务检查(玩家, '引导_一坐领取', '坐骑1_信字当头') then
        return
    end

    return '你找我有什么事？'
end

function NPC:NPC菜单(玩家, i)

end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
