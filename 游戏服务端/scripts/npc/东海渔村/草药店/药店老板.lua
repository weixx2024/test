local NPC = {}
local 对话 = [[
最近生意不好，要想想办法
menu
1|我想买点东西
2|我只是路过看看
]]
local 对话2 = [[
最近生意不好，要想想办法
menu
3|告诉我关于药品等必备道具的使用吧
1|我想买点东西
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('新手剧情')
    if r and r.进度 == 5 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/渔村药店.lua')

    end
end

return NPC
