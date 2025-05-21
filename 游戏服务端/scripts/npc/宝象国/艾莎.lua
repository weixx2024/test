local NPC = {}
local 对话 = [[我看到远方的夕阳落下，我看到宝象国的夜色;我看到胡杨林金灿灿的落叶，我看到林间的硕果....赶路人啊，你听从何方召唤的歌?
menu
宝象国皇宫
平顶山胡杨林
大雁塔
我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '宝象国皇宫' then
        玩家:切换地图(101529, 73, 135)
    elseif i == '平顶山胡杨林' then
        玩家:切换地图(1537, 21, 102)
    elseif i == '大雁塔' then
        玩家:切换地图(1001, 85, 228)
    end
end

return NPC
