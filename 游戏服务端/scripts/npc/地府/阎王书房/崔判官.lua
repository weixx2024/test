local NPC = {}
local 对话 = [[
现在好多人胆子真大，看到我居然不怕。
menu
1|我想要回长安
2|算了想想再说]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:切换地图(1001, 332, 24)
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
