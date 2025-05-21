local NPC = {}
local 对话 = [[
元宵快乐。
]]






function NPC:NPC对话(玩家)

    if not self:是否战斗中() then
        self:进入战斗(true)
        local r = 玩家:进入战斗('scripts/war/宝库_贪婪怪.lua')
        self:进入战斗(false)
        if r then
            self:删除()
        end
        return
    end


    return "我正在战斗中"
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
