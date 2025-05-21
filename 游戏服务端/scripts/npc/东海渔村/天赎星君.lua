local NPC = {}
local 对话 = [[
既然玉皇大帝有命，我这就送你入库寻宝，嘿嘿，小心宝没寻到，反而断送了性命，我劝你还是不要进入的好.
menu
1|进入天宫寻宝

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
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
