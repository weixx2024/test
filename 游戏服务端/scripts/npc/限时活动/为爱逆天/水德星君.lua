local NPC = {}
local 对话 = [[
真水无波，你们真要为那奎宿与我开战？
]]
local 对话2 = [[
真水无波，你们真要为那奎宿与我开战？
menu
1|你光棍哪里懂得类,开战！
2|我不会游泳，还是算了
]]
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务("为爱逆天")
    if r and r.进度 == 1 then
        return 对话2
    end

    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        -- local t = {}
        -- if not 玩家.是否队长 then
        --     return "该任务需要组队参加"
        -- end
        -- if 玩家:取队伍人数() < 5 then
        --     return "该任务需要5人参加"
        -- end

        -- for _, v in 玩家:遍历队伍() do
        --     if v:判断等级是否低于(90) then
        --         table.insert(t, v.名称)
        --     end
        -- end

        -- if #t > 0 then
        --     return table.concat(t, '、 ') .. '#W低于90级,无法挑战该任务!'
        -- end

        local r = 玩家:取任务("为爱逆天")
        if r and r.进度 == 1 then
            local sf = 玩家:进入战斗('scripts/war/限时活动/为爱逆天/水德星君.lua', self)
            if sf then
                return '火速去往#Y大唐境内(438,62)#W阻拦#G火德星君#W！'
            end
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
