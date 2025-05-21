local NPC = {}
local 对话 = [[我是帮派总管,帮中事物无论大小都经由我处理。
menu
1|我要领取帮派任务
2|我来取消帮派任务
3|我要升级帮派
4|报名参加帮战
99|什么都不想做
]]
--"我要领取帮派任务","我来取消帮派任务","离开"
--其它对话
function NPC:NPC对话(玩家, i)
    -- print(self.帮派,self.帮派.名称)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if not 玩家.帮派 or 玩家.帮派 == "" then
        return "你已经不是本帮成员了"
    end
    if 玩家.帮派 ~= self.帮派.名称 then
        return "非本帮派成员，不要参与本帮的事物#04"
    end
    if i == '1' then
        local 上限 = 30
        -- if 玩家.转生 > 0 then
        --     上限 = 30
        -- end




        if 玩家:取活动限制次数('帮派任务') >= 上限 then
            return "你今天已经完成了" .. 上限 .. "次帮派任务,明天再来吧！"
        end
        local rw = 玩家:取任务('日常_帮派任务')
        if rw then
            return "你身上有未完成的任务"
        end

        local r = 生成任务 { 名称 = '日常_帮派任务', 帮派 = 玩家.帮派 }
        if r and r:添加任务(玩家) then
            玩家:增加活动限制次数('帮派任务')
            return r.最后对话
        end

    elseif i == '2' then
        local r = 玩家:取任务('日常_帮派任务')
        if r then
            -- r:任务取消(玩家)
            r:删除(玩家)
        end


    elseif i == '3' then
        local r = self.帮派:升级条件检查(玩家.nid)
        if r == true then
            self.帮派:升级处理()
            return "升级成功"
        end
        return r
    elseif i == '4' then
        -- if self.帮派.等级 < 3 then
        --     return "帮派达到3级才可以参加帮战"
        -- end
        local r = self.帮派:帮战报名(玩家.nid)
        if r == true then
            return "报名成功"
        end
        return r
    end
end

function NPC:NPC给予(玩家, cash, items)
    if not 玩家.帮派 or 玩家.帮派 == "" then
        return "你已经不是本帮成员了"
    end
    if 玩家.帮派 ~= self.帮派.名称 then
        return "非本帮派成员，不要参与本帮的事物#04"
    end
    local r = 玩家:取任务("日常_帮派任务")
    if r then
        if items and items[1] then
            if items[1].名称 == r.物品 then
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    r:完成(玩家)
                    return '你做的非常好！'
                end
            end
            return
        end
    end
    return '你给我什么东西？'
end

return NPC

-- wb[1] = "我是专门为本帮成员驯养坐骑和召唤兽驯养师，想要召唤兽和坐骑迅速的强大起来我是可以帮你的。（#R/驯养坐骑经验与技能熟练度时，需骑乘需要驯养的坐骑；召唤兽驯养需将召唤兽设置成当前参战状态。）"
-- xx = {"我要提高坐骑经验","我要提高坐骑技能熟练度","我要驯养参战召唤兽亲密","什么都不想做。"}
