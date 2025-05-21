-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-07-19 06:33:17

local NPC = {}
local 对话 = [[
奉唐王之命，举办御前科举招才纳贤。天下所有有志之士都可以来我这报名，通过乡试、省试之后，名列前茅者可以进入殿试，有幸获得唐王的嘉奖。通过殿试名列三甲者还能金榜题名，成为本次科举的今科状元、榜眼、探花。
menu
1|我想报名文科比试
2|我想报名武科比试
3|我想了解规则
4|我想回家耕田
]]

local 对话2 = [[
你已经报名过了，唐王有令不能重复报名。如果再给你机会，唐王怪罪下来我可担当不起,除非……#17
menu
5|这有100W你拿去
]]



function NPC:NPC对话(玩家, i)
    if 科举是否开启报名() then
        return 对话
    end
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        if 玩家:取活动限制次数('武试') > 0 then
            return "每位玩家只能参加一种类型的科举"
        end
        玩家:增加活动限制次数('文试')
        if 玩家:取任务("乡试_文试") then
            return 玩家.名称 .. "身上有未完成的任务！"
        end
        local r = 生成任务 { 名称 = '乡试_文试' }
        if r and r:添加任务(玩家) then
            return '快去长安300.250找乡试考官1号进行乡试。'
        end
    elseif i == "2" then
        if 玩家:取活动限制次数('文试') > 0 then
            return "每位玩家只能参考一种类型的科举"
        end
        玩家:增加活动限制次数('武试')
        if 玩家:取任务("乡试_武试") then
            return 玩家.名称 .. "身上有未完成的任务！"
        end
        local r = 生成任务 { 名称 = '乡试_武试' }
        if r and r:添加任务(玩家) then
            return '快去长安300.250找乡试考官1号进行乡试。'
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
