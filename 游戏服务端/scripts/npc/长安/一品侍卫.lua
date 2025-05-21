local NPC = {}
local 对话 = {
    [[
奉唐王旨意,征召雇佣兵外出杀敌，凡有心效力朝廷,外出奋勇杀敌均有双倍经验奖励,雇用时间每人每星期24小时。你是否愿意外出杀敌?(你当前未领取的双倍时间还有%s小时)
menu
1|领取一小时
2|领取两小时
3|领取四小时
4|冻结双倍时间（10000两）
99|我只是路过看看
]],
    [[
你这次的雇佣时间为%s小时,希望你能奋勇杀敌。
menu
]],
    [[
你的雇佣双倍时间当前处于冻结状态,你是否确定要解开冻结双倍时间?(当前你的身上拥有的冻结双倍时间为%s分钟,本周你未领取的雇用时间还有%s小时)
menu
5|解冻双倍时间
99|我喜欢悠闲自在的生活,厌恶杀戮
]]
}

local 周双倍时长 = 24

function NPC:NPC对话(玩家)
    NPC.队伍对话 = true
    local r = 玩家:取任务('双倍时间')
    if r and r.冻结 then
        return string.format(对话[3], r.剩余时间 // 60, 周双倍时长 - 玩家:取双倍时间数据())
    end
    return string.format(对话[1], 周双倍时长 - 玩家:取双倍时间数据())
end
--

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取双倍(玩家, 1)
    elseif i == '2' then
        return self:领取双倍(玩家, 2)
    elseif i == '3' then
        return self:领取双倍(玩家, 4)
    elseif i == '4' then
        return self:冻结双倍(玩家)
    elseif i == '5' then
        return self:恢复双倍(玩家)
    end
end
function NPC:领取双倍(玩家, 时间)
    if 24 - 玩家:取双倍时间数据() >= 时间 then
        玩家:领取双倍时间(时间)
        local r = 玩家:取任务('双倍时间')

        if r then
            r:增加时长(玩家, 时间)
            return string.format(对话[2], 时间)
        else
            local n = 生成任务 {名称 = '双倍时间'}
            if n and n:添加任务(玩家, 时间) then
                return string.format(对话[2], 时间)
            end
        end
    end
    return '本周没有剩余可用双倍时间了#51'
end
function NPC:冻结双倍(玩家)
    local r = 玩家:取任务('双倍时间')
    if r and not r.冻结 then
        r:冻结双倍(玩家)
        return '已经帮你冻结了双倍时间#51'
    end

    return '你身上没有可冻结的双倍时间#51'
end

function NPC:恢复双倍(玩家)
    local r = 玩家:取任务('双倍时间')
    if r and r.冻结 then
        local 恢复时间 = r:恢复冻结(玩家)
        return string.format('已经帮你解开了冻结的双倍时间#51，你当前的身上的双倍时间是%s分钟，赶快去奋勇杀敌吧。', 恢复时间//60)
    end

    return '你身上没有可恢复的双倍时间#51'
end
return NPC
