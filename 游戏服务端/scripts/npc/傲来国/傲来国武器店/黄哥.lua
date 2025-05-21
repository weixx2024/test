local NPC = {}
local 对话 = [[
传说中的烈阳火种和寒阴火种最近又出现了，这两样火种可以炼阴阳火种，要是你能帮我拿到，我将可以打造更加厉害的兵器
menu
1|帮忙
2|我只是路过看看
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
