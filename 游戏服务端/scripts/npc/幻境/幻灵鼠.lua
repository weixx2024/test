local NPC = {}
local 对话 = [[
这个幻境的每一个角落，我都知道有什么，你想让我帮你找的话需要消耗一个天机密令哦！
menu
1|我要挑战普通难度
2|我要挑战困难难度
3|我要挑战卓越难度
4|我要挑战炼狱难度
99|妖怪太强大，快送我回家
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' or i == '2' or i == '3' or i == '4' then
        if not 玩家.是否组队 then
            return '需要3个人以上的组队来帮我'
        end
        if 玩家:取队伍人数() < 3 then
            return '需要3个人以上的组队来帮我'
        end

        local t = {}
        for _, v in 玩家:遍历队伍() do
            if v:判断等级是否低于(99) then --or not v:剧情称谓是否存在(8)
                table.insert(t, v.名称)
            end
        end

        if #t > 0 then
            return table.concat(t, '、 ') .. '#W低于100级,无法领取'
        end

        if self:扣除密令(玩家) then
            local rw = 生成任务 { 名称 = '日常_地宫', 难度 = tonumber(i) }
            if rw then
                return rw:添加任务(玩家)
            end
        end
    end

    if i == '99' then
        玩家:切换地图(1003, 229, 10)
    end
end

function NPC:扣除密令(玩家)
    local list = {}
    local t = {}
    local 通过 = true
    for _, v in 玩家:遍历队伍() do
        local r = v:取物品是否存在("天机密令")
        if r then
            table.insert(list, r)
        else
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示(table.concat(t, '、 ') .. "没有天机密令")
        return
    end
    for i, v in ipairs(list) do
        v:减少(1)
    end
    return true
end

return NPC
