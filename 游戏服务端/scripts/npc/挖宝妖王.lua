local NPC = {}

local 对话 = [[
小子你看什么看，吾乃此处妖王，若不速速离去，小心本王吃了你#211
menu
1|老子是来干你的，还不跪下
99|我只是到处转转
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        self:攻击事件(玩家)
    end
end

function NPC:攻击事件(玩家)
    if not self:是否战斗中() then
        self:进入战斗(true)
        local r = 玩家:进入战斗('scripts/war/妖王.lua')
        self:进入战斗(false)
        if r then
            self:删除()
        end
    end
end

return NPC
