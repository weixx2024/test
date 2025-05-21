local NPC = {}
local 对话 = [[长安虽然繁华热闹，但是有一个地方比长安更值得一去，那就是修罗古城。怎么？你想去么？
menu
1|请送我去吧 
2|请送我去灵兽村 
3|送我去修罗古城南 
99|不，我更喜欢繁华的长安
]]


--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(101381, 280, 159)
    elseif i=='2' then
        玩家:切换地图(101349, 226, 113)
    elseif i=='3' then
        玩家:切换地图(101381, 217, 40)
    end
end



return NPC