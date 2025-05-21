local NPC = {}
local 对话 = [[
最近小店生意兴隆，连我这掌柜也得亲自出马，这刚好人手紧缺，不知道大侠愿意打个下手帮个忙吗？
menu
1|有什么事情需要帮忙吗？
2|有急事，帮不了你了
3|我想了解下情况
4|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

local _任务列表 = {
    "宝图_捣蛋鬼",
    "宝图_解救小二",
    "宝图_送酒",
    "宝图_送金票",
    "宝图_狂妄书生",
}

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local name = _任务列表[math.random(#_任务列表)]
        local rw = 生成任务 { 名称 = name }
        if rw then
            return rw:添加任务(玩家)
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
