local NPC = {}
local 对话 = [[
这位大侠，您真是我碰到最尊贵的客人了。为您服务我真是太荣幸了！容小的斗胆问问，马车已经准备好了，请问您想去哪里？
menu
1|送我回自己的庭院
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        -- 玩家:切换地图(1195, 57, 100) 
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
