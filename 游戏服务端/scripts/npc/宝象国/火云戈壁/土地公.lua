local NPC = {}
local 对话 = [[少侠耳聪目慧，何不去孤竹城“听听佛法”？或有所悟,也未可知。
menu
1|送我去孤竹城
99|我是路过
]]
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == "1" then
        local r = 玩家:取任务("日常_孤竹城")
        if r then
            玩家:切换地图(101595, 4, 30)
        else
            local rw = 生成任务 { 名称 = '日常_孤竹城', 进度 = 1 }
            if rw then
                local t = rw:添加任务(玩家)
                if type(t) == "string" then
                    return t
                else
                    玩家:切换地图(101595, 4, 30)
                end
            end
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
