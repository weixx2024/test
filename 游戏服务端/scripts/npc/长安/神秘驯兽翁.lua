local NPC = {}
local 对话 = [[
年轻的时候，我走南闯北，见识到了无数的异兽。那是多么令人向往的情景啊。依稀记得，片片如雪的冰雪魔，通体金光的黄金兽，天生神力的泥石怪，夜夜哀怨的冥灵妃子，还有那轻易不见，传说中的神兽。所以，要是想知道与你有缘的召唤兽，找我就错不了的。
menu
1|玩法规则
2|我要购买好运礼包
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
