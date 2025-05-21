local NPC = {}
local 对话 = [[我是专门为本帮成员驯养宠物驯养师，想要宠物迅速提升等级我是可以帮你的
menu
1|我要驯养宠物经验
99|什么都不想做
]]

local 对话2 = [[我是专门为本帮成员驯养宠物驯养师，想要宠物迅速提升等级我是可以帮你的
menu
1|消耗100点成就提升宠物20000点经验
2|消耗1000点成就提升宠物200000点经验
]]


--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if not 玩家.帮派 or 玩家.帮派 == "" then
        return "你已经不是本帮成员了"
    end
    if 玩家.帮派 ~= self.帮派.名称 then
        return "非本帮派成员，不要参与本帮的事物#04"
    end

    if i == "1" then
        ::连续::
        local  sjc=  玩家:取当前时间宠()
        if not sjc then
            return "你还没有时间宠，可以找渔村宠物仙子领取"
        end
        if sjc.等级>=100 then
            return "你的时间宠等级已经达到上限！"
        end
        local r = 玩家:选择窗口(对话2)
        if r == "1" or r == "2" then
            local n = r == "1" and 100 or 1000
            local nn = r == "1" and 20000 or 20000000
            if 玩家:扣除帮派成就(n) then
                if 玩家:添加经验_时间宠(nn) then
                    玩家:提示窗口("#Y你的宠物经过驯养获得了" .. nn .. "点经验")
                end
                goto 连续
            else
                return "你没有那么多的帮派成就！我很为难啊#17"
            end
        end




    end
end

return NPC
