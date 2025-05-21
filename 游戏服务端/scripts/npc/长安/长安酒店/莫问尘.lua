local NPC = {}
local 对话 = [[
莫愁前路无知己，天下谁人不识君...糟糕，又没酒钱了....这位英雄，借点钱来花花？当然，我会用点小本事来和你做交换！
menu
1|正要找你，我想重新分配我的属性点
2|我是来打听，想了解下如何洗点
3|我只是路过看看
4|我只是路过看看
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
