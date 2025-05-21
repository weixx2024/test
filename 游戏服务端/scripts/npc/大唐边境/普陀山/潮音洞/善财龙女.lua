local NPC = {}
local 对话 = [[
我佛有三藏真经,可渡凡人成菩萨正果,不生不灭,不垢不净,与天地同寿，日月同庚，但是孩子一旦皈依我佛，则与世再无牵挂，从此与你尘缘尽无，再不回来!(宝宝出家后是无法找回的，请三思。)
menu
1|我想送孩子皈依佛门做个善财童子，弘扬佛法。
2|我再考虑一下
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return 玩家:出家孩子()
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
