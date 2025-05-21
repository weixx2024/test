local NPC = {}
local 对话 = [[
我画的图卡，在长安一带也算小有名气。
menu
1|购买变身卡
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:打开窗口("变身卡商店")
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
