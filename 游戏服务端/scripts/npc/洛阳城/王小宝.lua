local NPC = {}
local 对话 = [[
欢迎到来本酒店！这位客官看了是辛苦了，是要住店吧？
menu
1|我要住店
2|我只是向了解以下价钱
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
