local NPC = {}
local 对话 = [[
几处草莺争暖树，谁家新燕啄春泥。我是朝廷专派售卖庭院的官员，客官找我有何贵干？
menu
1|我要一个漂亮的新庭院（200000两）
2|我要升级我的房子
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
