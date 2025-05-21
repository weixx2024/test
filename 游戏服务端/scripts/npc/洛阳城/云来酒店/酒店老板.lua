local NPC = {}
local 对话 = [[
欢迎到来本酒店！这位客官看了是辛苦了，是要住店吧？
menu
1|我要住店
2|我只是向了解以下价钱
3|我只是路过看看
]]
local 对话2 = [[
哈哈，终于等到你来了！我这颗吊着的心可以放下啦#86累了吧，在我这里住店可以恢复哦
menu
4|初来休息
5|买酒路过
]]
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('新手剧情')
    if r and r.进度 == 8 then
        return 对话2
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if 玩家:扣除师贡(20000) then
            玩家:住店()
            return "你的气血、魔法得到恢复"
        end


    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
