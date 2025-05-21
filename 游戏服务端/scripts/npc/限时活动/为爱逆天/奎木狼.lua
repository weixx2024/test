local NPC = {}
local 对话 = [[
你也是来抓我的吧？爱一个人有什么错？要战便战！我绝不退避！
]]
local 对话2 = [[
你也是来抓我的吧？爱一个人有什么错？要战便战！我绝不退避！
menu
1|那便战！
2|我抓你干什么？我就路过打酱油的...
]]
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务("为爱逆天")
    if not r then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local t = {}
        if not 玩家.是否队长 then
            return "该任务需要组队参加"
        end
        if 玩家:取队伍人数() < 5 then
            return "该任务需要5人参加"
        end

        for _, v in 玩家:遍历队伍() do
            if v:判断等级是否低于(90) then
                table.insert(t, v.名称)
            end
        end

        if #t > 0 then
            return table.concat(t, '、 ') .. '#W低于90级,无法挑战该任务!'
        end

        if 玩家:取活动限制次数('为爱逆天') >= 1 then
            return "该任务每天最多领取1次"
        end

        local r = 玩家:取任务("为爱逆天")
        if not r then
            local sf = 玩家:进入战斗('scripts/war/限时活动/为爱逆天/奎木狼.lua', self)
            玩家:最后对话('成王败寇，我跟你们回天庭便是，只求少侠放过百花仙子！', NPC.头像, NPC.nid, NPC.结束)
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
