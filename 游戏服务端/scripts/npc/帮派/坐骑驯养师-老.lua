﻿local NPC = {}
local 对话 = [[我是专门为本帮成员驯养坐骑驯养师，想要坐骑迅速的强大起来我是可以帮你的（#R驯养坐骑经验与技能熟练度时，需骑乘需要驯养的坐骑#W）
menu
1|我要提高坐骑经验
2|我要提高坐骑技能熟练度
99|什么都不想做
]]


local 对话2 = [[我是专门为本帮成员驯养坐骑驯养师，想要坐骑迅速的强大起来我是可以帮你的（#R驯养坐骑经验与技能熟练度时，需骑乘需要驯养的坐骑#W）
menu
1|消耗2000成就提升7000点坐骑经验
2|消耗10000成就提升36000点坐骑经验
99|什么都不想做
]]

local 对话3 = [[我是专门为本帮成员驯养坐骑驯养师，想要坐骑迅速的强大起来我是可以帮你的（#R驯养坐骑经验与技能熟练度时，需骑乘需要驯养的坐骑#W）
menu
1|消耗2600点成就提升1600点坐骑技能熟练度
2|消耗20000点成就提升10000点坐骑技能熟练度
99|什么都不想做
]]
--其它对话
function NPC:NPC对话(玩家, i)
    -- if self.帮派.等级 < 2 then
    --     return "帮派达到2级再来找我吧"
    -- end
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

    if i == "1" then
        ::连续::
        local r = 玩家:选择窗口(对话2)
        if r == "1" or r == "2" then
            local zq = 玩家:取乘骑坐骑()
            if not zq then
                return "驯养坐骑经验与技能熟练度时，需骑乘需要驯养的坐骑"
            end

            if zq.等级>=100 then
                return "该坐骑等级已经达到上限"
            end


            local xh = r == "1" and 2000 or 30000
            local jy = r == "1" and 10000 or 96000
            if 玩家:扣除帮派成就(xh) then
                zq:添加经验(jy)
                玩家:常规提示("#Y你的坐骑获得" .. jy .. "点经验")
                goto 连续
            else
                return "你没有那么多的帮派成就！我很为难啊#17"
            end

        end
    elseif i == "2" then
        local r = 玩家:选择窗口(对话3)
        if r == "1" or r == "2" then
            local zq = 玩家:取乘骑坐骑()
            if not zq then
                return "驯养坐骑经验与技能熟练度时，需骑乘需要驯养的坐骑"
            end
            if zq:取技能数量() == 0 then
                return "你这只坐骑还没有学习任何技能呢！"
            end
            local xh = r == "1" and 2600 or 20000
            local jy = r == "1" and 1600 or 10000
            if 玩家:扣除帮派成就(xh) then
                zq:添加技能熟练度(jy)
                玩家:常规提示("#Y你的坐骑获得" .. jy .. "点技能熟练度")
            else
                return "你没有那么多的帮派成就！我很为难啊#17"
            end

        end

    end
end

return NPC

-- wb[1] = "我是专门为本帮成员驯养坐骑和召唤兽驯养师，想要召唤兽和坐骑迅速的强大起来我是可以帮你的。（#R/驯养坐骑经验与技能熟练度时，需骑乘需要驯养的坐骑；召唤兽驯养需将召唤兽设置成当前参战状态。）"
-- xx = {"我要提高坐骑经验","我要提高坐骑技能熟练度","我要驯养参战召唤兽亲密","什么都不想做。"}
