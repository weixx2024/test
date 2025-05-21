local NPC = {}
local 对话 = {
    [[我天天喝酒，喝死拉倒#28
menu
99|离开
]],
    [[我天天喝酒，喝死拉倒#28
menu
1|灌他
99|离开
]]
}
function NPC:NPC对话(玩家, i)
    -- if os.date('%w', os.time()) == '2' then --
    --     return 对话[2]
    -- end
    return 对话[2]
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家.是否队长 then
            return "3人或者3人以上挑战"
        end
        if 玩家:取队伍人数() < 3 then
            return "3人或者3人以上挑战"
        end
        if 玩家:判断等级是否低于(90, 0) then
            return "队伍内有低于0转90级的玩家无法挑战该任务"
        end
        local tt = {}
        for _, v in 玩家:遍历队伍() do
            if v:取活动限制次数('李白') >= 2 then
                table.insert(tt, v.名称)
            end
        end

        if #tt > 0 then
            return table.concat(tt, "、") .. "今日已经挑战过2次该任务"
        end



        if self:扣除西风烈(玩家) then
            local r = 玩家:进入战斗('scripts/war/李白.lua')
            if r then
                if 玩家.是否组队 then
                    for _, v in 玩家:遍历队伍() do
                        self:掉落包(v)
                    end
                else
                    self:掉落包(玩家)
                end
            end
        end
        -- return "上坟烧报纸 糊弄鬼呢#24 我要的西风烈呢？？？"
    end
end

function NPC:扣除西风烈(玩家)
    local list = {}
    local t = {}
    local 通过 = true
    for _, v in 玩家:遍历队伍() do
        local r = v:取物品是否存在("西风烈")
        if r then
            table.insert(list, r)
        elseif v.是否机器人 then
        else
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示(table.concat(t, '、 ') .. "没有西风烈")
        return
    end
    for i, v in ipairs(list) do
        v:减少(1)
    end
    return true
end

local _广播 = '#C玩家#R%s#C诗酒双绝，获得了李白赠送的#G#m(%s)[%s]#m#n#50'
function NPC:掉落包(玩家)
    if 玩家:取活动限制次数('李白') >= 2 then
        玩家:常规提示("#Y今日已经完成%s次，无法获得奖励", 2)
        return
    end
    玩家:增加活动限制次数('李白')


    local 掉落包 = 取掉落包('挑战', '李白')

    if 掉落包 then
        local 银子 = 10000
        local 经验 = 2489542
        local 法宝经验 = 480
        玩家:添加任务经验(经验)
        玩家:添加银子(银子)
        玩家:添加法宝经验(法宝经验)

        奖励掉落包物品(玩家, 掉落包, _广播)
    end
end

return NPC
