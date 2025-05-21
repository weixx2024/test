local NPC = {}
local 对话 = [[
雁塔佛地竟出现妖魔怨气，为了天下生灵，侠士您愿意赶赴塔中，为镇妖封魔而战吗？
menu
1|快送我去镇妖封魔
2|请大师告诉我详情
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家.是否组队 then
            玩家:常规提示('#Y需要5个人以上的组队来帮我！')
            return
        end
        -- if 玩家:取队伍人数() < 5 then
        --     玩家:常规提示('#Y需要5个人以上的组队来帮我！')
        --     return
        -- end

        local t = {}
        for _, v in 玩家:遍历队伍() do
            if v:判断等级是否低于(79) then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于80级,无法领取')
            return
        end

        local r = 玩家:取任务('日常_大雁塔副本')
        if r then
            r:进场(玩家)
            return
        end


        r = 生成任务 { 名称 = '日常_大雁塔副本' }
        if r and r:添加任务(玩家) then
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
