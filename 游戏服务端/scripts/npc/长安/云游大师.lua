local NPC = {}
local 对话 = [[
大唐盛世,人人安居乐业,社会虽安定固是好事,可对一些新来的朋友来说，他们人生道路总会遇到挫折失败,大师我有一个梦,就是想看到天下所有人都是一家，强者能够帮助帮助弱者，我现在可以找到一些需要帮助的人的替身，希望你能热心帮助这些迷茫中的新人，或许在这个过程中你能找到你当年的影子,善哉善哉。
menu
1|就交给我吧,我来帮助这些人
2|不想干了,帮我取消任务
3|我想了解下怎么帮助别人
99|没事路过,谢谢
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:取任务("日常_五环")
        if r then
            return "你身上已经有该任务了！"
        end
        if 玩家:取活动限制次数("五环") >= 1 then
            return "今天你已经完成1次该任务了,请明天再来"
        end
        if 玩家.转生 == 0 and 玩家.等级 < 80 then
            return "领取该任务需要80级"
        end
        local 五环令 = 玩家:取物品是否存在("五环令")
        if not 五环令 then
            return "领取该任务需要一个五环令"
        end

        local rw = 生成任务 { 名称 = '日常_五环' }
        if rw then
            local st = rw:添加任务(玩家)
            if st == true then
                五环令:减少(1)
                玩家:增加活动限制次数("五环")
                return rw.最后对话
            elseif type(st) == "string" then
                return st
            end
        end
    elseif i == '2' then
        local r = 玩家:取任务("日常_五环")
        if r then
            r:任务取消(玩家)
        end
    end
end

return NPC
