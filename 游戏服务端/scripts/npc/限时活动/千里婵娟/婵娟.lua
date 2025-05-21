local NPC = {}
local 对话 = [[
生逢乱世，亲朋爱侣，天各一方。寄语婵娟，愿逐月华，流照远人
menu
1|我来出点力
2|爱莫能助
]]
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local t = {}

        -- if not 玩家.是否组队 or not 玩家.是否队长 then
        --     return "需要3人及以上人员参加"
        -- end
        -- if 玩家:取队伍人数() < 3 then
        --     return "需要3人及以上人员参加"
        -- end
        -- for _, v in 玩家:遍历队伍() do
        --     if v:判断等级是否低于(90) then
        --         table.insert(t, v.名称)
        --     end
        -- end
        -- if #t > 0 then
        --     return table.concat(t, '、') .. '低于90级,无法领取'
        -- end

        for _, v in 玩家:遍历队伍() do
            if 玩家:取任务("千里婵娟") then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            return table.concat(t, "、") .. "身上有未完成的任务！"
        end

        for _, v in 玩家:遍历队伍() do
            if 玩家:取活动限制次数('千里婵娟领取') >= 5 then
                table.insert(t, v.名称)
            end
        end

        if #t > 0 then
            return table.concat(t, "、") .. "今日已经领取过五次了,无法再次领取！"
        end

        local r = 生成任务 { 名称 = '千里婵娟' }
        if r and r:添加任务(玩家) then
            return '快去大唐境内233.134找看看红拂女最近过的如何？'
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
