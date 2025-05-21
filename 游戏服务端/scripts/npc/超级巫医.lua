local NPC = {}
local 对话 = [[
我是超级巫医，可以帮你医治召唤兽和增加召唤兽忠诚、喂养坐骑和修理召唤兽饰品。客官，想要做点什么呢？
menu
1|全部医治和修复
2|查看召唤兽亲密值
3|我的召唤兽宝贝伤得厉害，治疗一下它并提高他的忠诚度吧
99|原来你是这样一个医生啊，有需要再找你
]]

function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local yzxh = 玩家:取巫医消耗()
        if yzxh == 0 then
            return "你的宝贝们可健康的不得了！"
        end
        local n = 玩家:确认窗口("你确定花费%s两银子恢复所有召唤兽的状态么？", yzxh)
        if 玩家.银子 < yzxh then
            return "你没有那么多银子"
        end
        if n then
            玩家:扣除师贡(yzxh)
            玩家:超级巫医()
            return "你的所有召唤兽得到恢复。"
        end
    elseif i == '2' then
        local r = 玩家:取参战召唤兽()
        if not r then
            return "请先将需要查看的召唤兽设置为参战状态"
        end
        return string.format("你与#G%s#W的亲密度为#Y%s", r.名称, r.亲密)
    elseif i == '3' then
        local r = 玩家:取参战召唤兽()
        if r then
            local yzxh = 0
            local qxxh = (r.最大气血 - r.气血) / 100
            local mfxh = (r.最大魔法 - r.魔法) / 100
            local zcxh = (100 - r.忠诚) * 450
            yzxh = math.ceil(qxxh + mfxh + zcxh)
            if yzxh == 0 then
                return "你的宝贝可健康的不得了！"
            end
            local n = 玩家:确认窗口("你确定花费%s两银子恢复%s的状态么？", yzxh, r.名称)
            if 玩家.银子 < yzxh then
                return "你没有那么多银子"
            end
            if n then
                玩家:扣除师贡(yzxh)
                r:超级巫医()
                return "你的召唤兽" .. r.名称 .. "得到恢复。"
            end
        else
            return "请先将需要治疗的召唤兽参战！"
        end
    elseif i == '4' then
    elseif i == '99' then

    end
end

return NPC
