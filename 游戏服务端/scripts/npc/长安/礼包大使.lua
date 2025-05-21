local NPC = {}
local 对话 = [[
在我这里可以领取各式各样的礼包#86
menu
1|领取累计礼包

99|我只是路过看看
]]
--2|领取单笔礼包
function NPC:NPC对话(玩家, i)
    return 对话
end



function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local t = 玩家:取累积礼包列表()
        local list = {}
        for i, v in ipairs(t) do
            if v.领取id == 0 and v.领取时间 == 0 then
                table.insert(list, {
                    编号 = i,
                    名称 = v.名称
                })
            end
        end
        if not next(list) then
            return "你没有可领取的礼包哦"
        end
        local xx = {}
        for i, v in ipairs(list) do
            table.insert(xx, v.编号 .. "|" .. v.名称)
        end
        local r = 玩家:选择窗口("menu\n " .. table.concat(xx, "\n "))

        if r then
            return 玩家:领取累积礼包(r + 0)
        end

    elseif i == "2" then
        local t = 玩家:取单笔礼包列表()
        local list = {}
        for i, v in ipairs(t) do
            if v.领取id == 0 and v.领取时间 == 0 then
                table.insert(list, {
                    编号 = i,
                    名称 = v.名称
                })
            end
        end
        if not next(list) then
            return "你没有可领取的礼包哦"
        end
        local xx = {}
        for i, v in ipairs(list) do
            table.insert(xx, v.编号 .. "|" .. v.名称)
        end
        local r = 玩家:选择窗口("menu\n " .. table.concat(xx, "\n "))

        if r then
            return 玩家:领取单笔礼包(r + 0)
        end




    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
