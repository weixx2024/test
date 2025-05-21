local NPC = {}
local 对话 = [[
我是帮派大战的场内传送人。你可以通过我进入挑战场挑战对方强队或者进入战场为帮杀敌。
menu
1|我要回总部
2|我要回长安
4|我要挑战对方高手
3|离开
]]


function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:返回帮战总部()
    elseif i == '2' then
        玩家:龙神帮战退场()
    elseif i == '3' then
    elseif i == '4' then
        if not 玩家.是否组队 then
            return '该任务需要组队进行！'
        end
        if 玩家:取队伍人数() < 5 then
            return '该任务需要5人组队进行！'
        end
        玩家:参加帮派挑战()
    end
end

return NPC