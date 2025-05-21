local NPC = {}

local 对话 = [[
可寻到心意的宝物？
menu
1|传送至下一层
99|我还要再转转
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 取事件('天宫寻宝')
        if not r or r.是否结束 then
            return '还没有到活动开始时间'
        end
        return r:进入副本(玩家)
    end
end

function NPC:NPC给予(玩家, cash, items)
end

return NPC
