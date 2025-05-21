local NPC = {}
local 对话 = [[
    强大的勇士，你已经完成了8轮试练了么？
    menu
    1|完成试炼
    99|罢了
]]

function NPC:NPC对话(玩家)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:取任务('日常_孤竹城')
        if r  then
            if not r:是否完成(玩家) then
                return "你还没有完成8轮挑战"
            end
        else
            return "你没有这样的任务"
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
