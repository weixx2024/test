local NPC = {}
local 对话 = [[
唐王希望大唐子民多关系国事，特派遣我了解大家对时事的了解程度，我的问题有能答对者将会获得奖励，如果全部答对更有厚礼相赠。
menu
1|我要参加有奖问答
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('日常_大理寺答题')
    if r then
        return r.tz
    end

    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if 玩家:取任务('日常_大理寺答题') then
            return
        end
        if 玩家:取活动限制次数('大理寺答题') >= 1 then
            return "今日答题次数已用完,明天再来吧"
        end
        local r = 生成任务 { 名称 = '日常_大理寺答题' }
        if r and r:添加任务(玩家) then
            return r.tz
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
