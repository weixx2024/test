local NPC = {}
local 对话 ={ [[
奉国王令，临时征召雇佣兵，凡有心效力之人，外出奋勇降魔的一律五倍经验嘉奖，雇佣时间每人每天1小时。你是否愿意为吾王效力? ？
menu
1|领取一小时
2|冻结五倍时间（10000两）
99|我只是路过看看
]],
[[
你这次的雇佣时间为%s小时,希望你能奋勇杀敌。
menu
]],
[[
你的雇佣五倍时间当前处于冻结状态,你是否确定要解开冻结五倍时间?(当前你的身上拥有的冻结五倍时间为%s分钟)
menu
3|解冻五倍时间
99|我喜欢悠闲自在的生活,厌恶杀戮
]]
}
--4|查看我的剩余五倍时间
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('五倍时间')
    if r and r.冻结 then
        return string.format(对话[3], r.剩余时间 // 60)
    end
    return 对话[1]
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取五倍(玩家, 1)
    elseif i == '2' then
        return self:冻结五倍(玩家)
    elseif i == '3' then
        return self:恢复五倍(玩家)

    end
end
function NPC:领取五倍(玩家, 时间)
    if 1 - 玩家:取五倍时间数据() >= 时间 then
        玩家:领取五倍时间(时间)
        local r = 玩家:取任务('五倍时间')
        if r then
            r:增加时长(玩家, 时间)
            return string.format(对话[2], 时间)
        else
            local n = 生成任务 {名称 = '五倍时间'}
            if n and n:添加任务(玩家, 时间) then
                return string.format(对话[2], 时间)
            end
        end
    end
    return '今日没有剩余可用五倍时间了#51'
end
function NPC:冻结五倍(玩家)
    local r = 玩家:取任务('五倍时间')
    if r and not r.冻结 then
        r:冻结五倍(玩家)
        return '已经帮你冻结了五倍时间#51'
    end

    return '你身上没有可冻结的五倍时间#51'
end

function NPC:恢复五倍(玩家)
    local r = 玩家:取任务('五倍时间')
    if r and r.冻结 then
        local 恢复时间 = r:恢复冻结(玩家)
        return string.format('已经帮你解开了冻结的五倍时间#51，你当前的身上的五倍时间是%s分钟，赶快去奋勇杀敌吧。', 恢复时间//60)
    end

    return '你身上没有可恢复的五倍时间#51'
end
return NPC
