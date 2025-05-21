local NPC = {}
local 对话 = [[
今年唐王举办孔子诞辰,我这生意也变得分外红火,到底是生逢盛世啊!每天都来订做衣服的客官络绎不绝,忙得连休息的时间都没有#52客官是香也想订做衣服?一件100000金钱。
menu
1|为了参拜圣人,我想订做衣服
99|我只是路过,瞧瞧行情来着
]]





function NPC:NPC对话(玩家)

    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if 玩家:扣除银子(100000,"其它")  then
            local r = 生成任务 { 名称 = '孔庙祭祀_祭拜' }
            if r and r:添加任务(玩家) then
                return "好了,这是你订做的衣服"
            end
        else
            return "你没有那么多以你这"
        end


    elseif i == '2' then
        return 对话2
    end
end

return NPC
