local NPC = {}
local 对话 = [[
在我这里可以回收五级神兵(5000仙玉)六级神兵(30000仙玉)五常神兽(6000仙玉)#86
menu
1|神兵回收
2|神兽回收
99|我只是路过看看
]]


function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)

    if i == "1" then
        if  not  玩家.交易锁 then
            return '请先解除交易锁'
        end
        玩家:打开给予窗口(self.nid)
    elseif i == "2" then
        if  not  玩家.交易锁 then
            return '请先解除交易锁'
        end
        local r = 玩家:取参战召唤兽()
        if not r then
            return '请先把召唤兽设置成参战状态'
        end
        if r:取管制() then
            return '请先取消该召唤兽的管制状态'
        end
        if r.禁止交易 then
            return '禁止交易的召唤兽，你糊弄鬼呢#04'
        end
        if r.类型 ~= 7 then
            return '我这里可不是什么都收的，必须是五常神兽才可以！'
        end
        local qr = 玩家:确认窗口("你这只#R%s#W我出#G6000#W仙玉,童叟无欺,你确认卖给我么？#r#R注:请先确认内丹是否已经吐出 回收将内丹一起回收" , r.名称)
        if qr then
            if r:删除()then
                玩家:添加仙玉(6000)
                return "哈哈...今天又赚了一笔#18"
            end
        end







    end
end

function NPC:NPC给予(玩家, cash, items)
    if items and items[1] then
        if items[1].神兵 then
            local xy = 0
            if items[1].等级 == 6 then
                xy = 30000
            elseif items[1].等级 == 5 then
                xy = 5000
            else
                return '神兵倒是神兵，可是你这等级不够看啊。#18'
            end
            local name = items[1].原名
            local r = 玩家:确认窗口("你这件#R%s#W我出#G%s#W仙玉,童叟无欺,你确认卖给我么？", name
                , xy)
            if r then
                items[1]:接受(1)
                玩家:添加仙玉(xy)
                return "哈哈...今天又赚了一笔#18"
            end

        else
            return '神兵 神兵 神兵 少拿垃圾来糊弄我！#04'
        end
    end
    return '你给我什么东西？'
end

return NPC
