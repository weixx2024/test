local NPC = {}
local 对话 = [[
menu
1|我要捐款
99|什么都不想做
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
    if i == '1' then
        local r = 玩家:数值输入窗口("", "请输入你要捐献的银子数量#17！")
        if r then
            if 玩家:扣除银子(r) then
                self.帮派:添加财产值(r)
                self.帮派:帮派捐款(玩家.nid, r)
                玩家:帮派捐款(r)
                return "感谢为帮派建设的贡献#17"
            else
                return "貌似你也是囊中羞涩啊#24装什么大尾巴狼#04"
            end
        end
    end
end

return NPC

-- wb[1] = "我是专门为本帮成员驯养坐骑和召唤兽驯养师，想要召唤兽和坐骑迅速的强大起来我是可以帮你的。（#R/驯养坐骑经验与技能熟练度时，需骑乘需要驯养的坐骑；召唤兽驯养需将召唤兽设置成当前参战状态。）"
-- xx = {"我要提高坐骑经验","我要提高坐骑技能熟练度","我要驯养参战召唤兽亲密","什么都不想做。"}
