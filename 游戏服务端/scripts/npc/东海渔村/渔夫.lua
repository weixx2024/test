local NPC = {}
local 对话 = [[我这这渔村出去的都有一番大作为！请问你要去哪里呢？
menu
]]
local 对话2 = '少侠，外面很危险！还是先找#Y渔村村长#W磨练磨练，将等级提升至10级后再来吧！'


local 对话3 = [[在外面混好了记得常回来看看，如果混的差就别回来了#35
menu
]]

local 选项 = [[1|长安城东
2|长安城
我什么都不想做]]
local 选项2 = [[3|我要去长安
如果不急着走的话，在海边看看风景也好。]]

--其它对话
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务("新手剧情")
    if r and r.进度 == 7 then
        return 对话3 .. 选项2
    end
    return 对话 .. 选项
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if 玩家.等级 < 10 then
            return 对话2
        end
        玩家:切换地图(1193, 305, 181)
    elseif i == '2' then
        if 玩家.等级 < 10 then
            return 对话2
        end
        --就这么改就行 你会不 回了
        玩家:切换地图(1001, 248, 94)
    end
end

return NPC
