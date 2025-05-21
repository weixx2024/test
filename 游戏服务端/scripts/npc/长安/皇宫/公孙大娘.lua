local NPC = {}
local 对话 = [[
长安有东、西两个城门，出了城门有时会有妖怪出没，可要小心啊。
menu
1|我要带孩子拜师(剑舞)
2|我要进行孩子修炼
3|我要使用高级物品进行孩子修炼
4|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:取参战孩子()
        if not r then
            return "请先将要拜师的孩子设置参战状态"
        end

        return r:拜师('剑舞')
    elseif i == '2' then
        local r = 玩家:取参战孩子()
        if not r then
            return "请先将要修炼的孩子设置参战状态"
        end

        local rr = r:职业检查('剑舞')
        if type(rr) == 'string' then
            return rr
        end

        local i = 玩家:选择窗口('修炼一次需要扣一本#Y剑诀#W，请选择你要修炼的属性！\nmenu\n1|气质\n\n2|悟性\n\n3|智力\n\n4|内力\n\n5|耐力')
        if not i then
            return
        end

        if r then
            r:修炼(tonumber(i), '剑诀')
        end
    elseif i == '3' then
        local r = 玩家:取参战孩子()
        if not r then
            return "请先将要修炼的孩子设置参战状态"
        end

        local rr = r:职业检查('剑舞')
        if type(rr) == 'string' then
            return rr
        end

        local i = 玩家:选择窗口('修炼一次需要扣一本#Y高级剑诀#W，请选择你要修炼的属性！\nmenu\n1|气质\n\n2|悟性\n\n3|智力\n\n4|内力\n\n5|耐力')
        if not i then
            return
        end

        if r then
            r:修炼(tonumber(i), '高级剑诀', true)
        end
    elseif i == '4' then
    end
end

return NPC
