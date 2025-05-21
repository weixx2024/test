-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-29 08:42:29
-- @Last Modified time  : 2022-09-02 10:08:45
local NPC = {}
local 对话 = [[
我们是小本生意，如果还抽那么高的税，可就活不下去了。
menu
1|我想用银子买点东西
9|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    NPC.队伍对话 = true
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安杂货店.lua')
    elseif i == '2' then
    end
end

return NPC
