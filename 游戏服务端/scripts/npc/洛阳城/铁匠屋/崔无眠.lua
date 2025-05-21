local NPC = {}
local 对话 = [[
你想做什么？
menu
1|我要灌输灵气
2|我要升级仙器
3|我要用一阶仙器炼化仙器
4|我要用悔梦石重炼仙器
99|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:灌输灵气窗口()
    elseif i == '2' then
        玩家:仙器升级窗口()
    elseif i == '3' then
        玩家:仙器炼化窗口()
    elseif i == '4' then
        玩家:仙器重铸窗口()
    end
end

return NPC
