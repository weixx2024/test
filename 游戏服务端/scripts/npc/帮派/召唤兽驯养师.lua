local NPC = {}
local 对话 = [[我是专门为本帮成员驯养召唤兽驯养师，想要召唤兽迅速的强大起来我是可以帮你的（#R召唤兽驯养需将召唤兽设置成当前参战状态#W）
menu
1|我要驯养参战召唤兽亲密
2|我要驯养宠物经验
99|什么都不想做
]]

local 对话2 = [[我是专门为本帮成员驯养召唤兽驯养师，想要召唤兽迅速的强大起来我是可以帮你的（#R召唤兽驯养需将召唤兽设置成当前参战状态#W）
menu
1|消耗100点成就提升当前召唤兽4500点亲密
2|消耗1000点成就提升当前召唤兽45000点亲密
]]

local 对话3 = [[我是专门为本帮成员驯养召唤兽驯养师，想要召唤兽迅速的强大起来我是可以帮你的（#R召唤兽驯养需将召唤兽设置成当前参战状态#W）
menu
1|消耗100点成就提升宠物20000点经验
2|消耗1000点成就提升宠物200000点经验
]]


--其它对话
function NPC:NPC对话(玩家, i)
    -- if self.帮派.等级 < 2 then
    --     return "帮派达到2级再来找我吧"
    -- end
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
        local r = 玩家:选择窗口(对话2)
        if r == "1" or r == "2" then
            local zh = 玩家:取参战召唤兽()
            if not zh then
                return "召唤兽驯养需将召唤兽设置成当前参战状态"
            end
            local n = r == "1" and 100 or 1000
            local nn = r == "1" and 4500 or 45000
            if 玩家:扣除帮派成就(n) then
                if zh:添加亲密度(nn, 1) then
                    玩家:提示窗口("#Y你的" .. zh.名称 .. "经过驯养获得了" .. nn .. "点亲密度")
                end
            else
                return "你没有那么多的帮派成就！我很为难啊#17"
            end
        end
    elseif i == "2" then
        local r = 玩家:选择窗口(对话3)
        if r == "1" or r == "2" then
            local n = r == "1" and 100 or 1000
            local nn = r == "1" and 20000 or 200000
            if 玩家:扣除帮派成就(n) then
                if 玩家:添加经验_时间宠(nn) then
                    玩家:提示窗口("#Y你的宠物经过驯养获得了" .. nn .. "点经验")
                end
            else
                return "你没有那么多的帮派成就！我很为难啊#17"
            end
        end




    end
end

return NPC
