local NPC = {}
local 对话 = [[
这里的蟠桃可是五百年一开花，五百年一结果，五百年一熟的呀～
menu
1|有什么可以帮忙的(领取200环任务链)
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if 玩家.转生 == 0 and 玩家.等级 < 90 then
            return "90级再来找我把"
        end
        if 玩家:取周限次数("200环") >= 2 then
            return "本周次数已用完 下次再来吧"
        end
        local rw = 玩家:取任务('日常_200环')
        if rw then
            return "你身上有未完成得任务"
        end
        local 令牌 = 玩家:取物品是否存在("200环令")
        if not 令牌 then
            return "领取该任务需要一个200环令"
        end
        local 分类 = math.random(2)

        if math.random(100) < 20 then
            分类 = 3
        end



        local rw = 生成任务({ 名称 = "日常_200环", 分类 = 分类 })
        local r = rw:添加任务(玩家)
        if r == true then
            令牌:减少(1)
            return rw.最后对话
        else
            return r
        end


    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
