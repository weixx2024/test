local NPC = {}
local 对话 = [[
吾乃是守护天帝宝库大将。
menu
1|我要进入下一层
2|我要返回上一层
3|我什么都不想做
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 天宫寻宝_传送下一层(1)
        if r == true then
            玩家:切换地图(021197, 74, 51)
        else
            return r
        end
    elseif i == '2' then
        玩家:切换地图(011293, 60, 36)
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
